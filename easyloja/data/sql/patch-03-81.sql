DROP TABLE IF EXISTS ncm_data CASCADE;
-- origem da informação
-- portal.siscomex.gov.br/informativos/lista-ncm-x-ume
CREATE TABLE ncm_data
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  description varchar,
  code varchar,
  is_active boolean,
  unit varchar,

-- PK
  CONSTRAINT ncm_data_id_pkey PRIMARY KEY (id ),

-- FOREIGN KEYS
  CONSTRAINT ncm_data_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT ncm_data_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT ncm_data_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT ncm_data_te_modified_id_key UNIQUE (te_modified_id)

);

DROP SEQUENCE IF EXISTS ncm_data_id_seq CASCADE;

CREATE SEQUENCE ncm_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

COPY ncm_data(id, code, description, is_active, unit) FROM stdin DELIMITER ';';
1;01012100;Cavalos reprodutores de raca pura;1;UN
2;01012900;Cavalos, exceto reprodutores de raca pura;1;UN
3;01013000;Animais especie asinina/muar, reprodutores de raca pura;1;UN
4;01019000;Animais especie asinina/muar, exceto reprodutores de raca pura;1;UN
5;01022110;Bovinos reprodutores raca pura, prenhe ou com cria ao pe;1;UN
6;01022190;Outros bovinos reprodutores de raca pura;1;UN
7;01022911;Outros bovinos para reproducao, prenhe ou com cria ao pe;1;UN
8;01022919;Outros bovinos para reproducao;1;UN
9;01022990;Outros bovinos vivos;1;UN
10;01023110;Bufalos reprodutores de raca pura, prenhe ou com cria ao pe;1;UN
11;01023190;Outros bufalos reprodutores de raca pura;1;UN
12;01023911;Outros bufalos para reproducao, exceto raca pura, prenhe ou com cria ao pe;1;UN
13;01023919;Outros bufalos para reproducao, exceto reprodutores de raca pura;1;UN
14;01023990;Outros bufalos;1;UN
15;01029000;Outros animais vivos da especie bovina;1;UN
16;01031000;Suinos reprodutores de raca pura;1;UN
17;01039100;Outros suinos vivos, de peso inferior a 50 kg;1;UN
18;01039200;Outros suinos vivos, de peso igual ou superior a 50kg;1;UN
19;01041011;Ovinos reprodutores de raca pura, prenhe/com cria ao pe;1;UN
20;01041019;Outros ovinos reprodutores de raca pura;1;UN
21;01041090;Outros ovinos vivos;1;UN
22;01042010;Caprinos reprodutores de raca pura;1;UN
23;01042090;Outros caprinos vivos;1;UN
24;01051110;Galos e galinhas, peso <= 185 g, de linha pura/hibrida, para reproducao;1;UN
25;01051190;Outros galos e galinhas, vivos, peso nao superior a 185g;1;UN
26;01051200;Peruas e perus, vivos, de peso nao superior a 185g;1;UN
27;01051300;Patos;1;UN
28;01051400;Gansos;1;UN
29;01051500;Galinhas-dangola (pintadas);1;UN
30;01059400;Outros galos e galinhas, vivos, de peso <= 2.000 g;1;UN
31;01059900;Patos, gansos, perus, peruas e pintadas, vivos, de peso >185 g;1;UN
32;01061100;Mamiferos primatas, vivos;1;UN
33;01061200;Baleias, golfinhos e botos (mamiferos da ordem dos cetaceos), peixes-boi (manatins) e dugongos (mamiferos da ordem dos sirenios), otarias e focas, leoes-marinhos e morsas (mamiferos da subordem dos pinipedes);1;UN
34;01061300;Camelos e outros camelideos (Camelidae), vivos;1;UN
35;01061400;Coelhos e lebres, vivos;1;UN
36;01061900;Outros mamiferos vivos;1;UN
37;01062000;Repteis (incluindo as serpentes e as tartarugas marinhas);1;UN
38;01063100;Aves de rapina;1;UN
39;01063200;Psitaciformes (incluindo os papagaios, os periquitos, as araras e as cacatuas);1;UN
40;01063310;Avestruzes (Struthio camelus), para reproducao;1;UN
41;01063390;Outros avestruzes;1;UN
42;01063900;Outras aves vivas;1;UN
43;01064100;Abelhas;1;KG
44;01064900;Outros insetos;1;KG
45;01069000;Outros animais vivos;1;UN
46;02011000;Carcacas e meias carcacas de bovino, frescas ou refrigeradas;1;KG
47;02012010;Quartos dianteiros nao desossadados de bovino, frescos/refrigerados;1;KG
48;02012020;Quartos traseiros nao desossados de bovino, frescos/refrigados;1;KG
49;02012090;Outras pecas nao desossadas de bovino, frescas ou refrigeradas;1;KG
50;02013000;Carnes desossadas de bovino, frescas ou refrigeradas;1;KG
51;02021000;Carcacas e meias-carcacas de bovino, congeladas;1;KG
52;02022010;Quartos dianteiros nao desossados de bovino, congelados;1;KG
53;02022020;Quartos traseiros nao desossados de bovino, congelados;1;KG
54;02022090;Outras pecas nao desossadas de bovino, congeladas;1;KG
55;02023000;Carnes desossadas de bovino, congeladas;1;KG
56;02031100;Carcacas e meias-carcacas de suino, frescas ou refrigeradas;1;KG
57;02031200;Carcacas e meias-carcacas de suino, frescas ou refrigeradas;1;KG
58;02031900;Outras carnes de suino, frescas ou refrigeradas;1;KG
59;02032100;Carcacas e meias-carcacas de suino, congeladas;1;KG
60;02032200;Pernas, pas e pedacos nao desossados de suino, congelados;1;KG
61;02032900;Outras carnes de suino, congeladas;1;KG
62;02041000;Carcacas e meias-carcacas de cordeiro, frescas ou refrigeradas;1;KG
63;02042100;Carcacas e meias-carcacas de ovino, frescas ou refrigeradas;1;KG
64;02042200;Outras pecas nao desossadas de ovino, frescas ou refrigeradas;1;KG
65;02042300;Carnes desossadas de ovino, frescas ou refrigeradas;1;KG
66;02043000;Carcacas e meias-carcacas de cordeiro, congeladas;1;KG
67;02044100;Carcacas e meias-carcacas de ovino, congeladas;1;KG
68;02044200;Outras pecas nao desossadas de ovino, congeladas;1;KG
69;02044300;Carnes desossadas de ovino, congeladas;1;KG
70;02045000;Carnes de caprino, frescas, refrigeradas ou congeladas;1;KG
71;02050000;Carnes de animais das especies cavalar, asinina e muar, frescas, refrigeradas ou congeladas.;1;KG
72;02061000;Miudezas comestiveis de bovino, frescas ou refrigeradas;1;KG
73;02062100;Linguas de bovino, congeladas;1;KG
74;02062200;Figados de bovino, congelados;1;KG
75;02062910;Rabos de bovino, congelados;1;KG
76;02062990;Outras miudezas comestiveis de bovino, congeladas;1;KG
77;02063000;Miudezas comestiveis de suino, frescas ou refrigeradas;1;KG
78;02064100;Figados de suino, congelados;1;KG
79;02064900;Outras miudezas comestiveis de suino, congeladas;1;KG
80;02068000;Miudezas comestiveis, de ovino, etc, frescas/refrigeradas;1;KG
81;02069000;Miudezas comestiveis, de ovino, caprino, etc, congeladas;1;KG
82;02071100;Carnes de galos/galinhas, nao cortadas em pedacos, frescas/refrigeradas;1;KG
83;02071200;Carnes de galos/galinhas, nao cortadas em pedacos, congelala;1;KG
84;02071300;Pedacos e miudezas, de galos/galinhas, frescos/refrigerados;1;KG
85;02071400;Pedacos e miudezas, comestiveis de galos/galinhas, congelados;1;KG
86;02072400;Carnes de peruas/perus, nao cortadas em pedacos, frescas/refrigeradas;1;KG
87;02072500;Carnes de peruas/perus, nao cortadas em pedacos, congeladas;1;KG
88;02072600;Carnes de peruas/perus, em pedacos, miudezas, frescas/refrigeradas;1;KG
89;02072700;Carnes de peruas/perus, em pedacos e miudezas, congeladas;1;KG
90;02074100;Carnes de patos, naoo cortada em pedacos, frescas ou refrigeradas;1;KG
91;02074200;Carnes de patos, nao cortadas em pedacos, congeladas;1;KG
92;02074300;Figados gordos (foies gras) de patos, frescos ou refrigerados;1;KG
93;02074400;Outras carnes de patos, frescas ou refrigeradas;1;KG
94;02074500;Outras carnes de patos, congeladas;1;KG
95;02075100;Carnes de gansos, nao cortada em pedacos, frescas ou refrigeradas;1;KG
96;02075200;Carnes de gansos, nao cortadas em pedacos, congeladas;1;KG
97;02075300;Figados gordos (foies gras) de gansos, frescos ou refrigerados;1;KG
98;02075400;Outras carnes de gansos, frescas ou refrigeradas;1;KG
99;02075500;Outras carnes de gansos, congeladas;1;KG
100;02076000;Carnes de galinhas dangola (pintadas);1;KG
101;02081000;Carnes/miudezas, de coelhos/lebres, frescas/refrigeradas/congeladas;1;KG
102;02083000;Carnes de primatas, congeladas, frescas, refrigeradas;1;KG
103;02084000;Carnes de baleias, etc, congeladas, frescas, refrigeradas;1;KG
104;02085000;Carnes de repteis, congeladas, frescas, refrigeradas;1;KG
105;02086000;Outras carnes/miudezas comestiveis, de camelos e outros camelideos;1;KG
106;02089000;Carnes e miudezas, de outros animais, frescas/refrigeradas/congeladas;1;KG
107;02091011;Toucinho de porco, fresco, refrigerado ou congelado;1;KG
108;02091019;Outros toucinhos de porco;1;KG
109;02091021;Gordura de porco, fresca, refrigerada ou congelada;1;KG
110;02091029;Outras gorduras de porco;1;KG
111;02099000;Outros toucinhos e gorduras;1;KG
112;02101100;Pernas/pas/pedacos, de suino, nao desossados, salgados, etc.;1;KG
113;02101200;Barrigas e peitos, entremeados, de suino, salgados, etc.;1;KG
114;02101900;Outras carnes de suino, salgadas ou em salmoura, secas, etc.;1;KG
115;02102000;Carnes de bovinos, salgadas/em salmoura/secas/defumadas;1;KG
116;02109100;Carnes de primatas, salgadas, secas, etc.;1;KG
117;02109200;Carnes de baleias, etc, salgadas, secas, etc.;1;KG
118;02109300;Carnes de repteis, salgadas, secas, etc.;1;KG
119;02109900;Carnes de outros animais, salgadas, secas, etc.;1;KG
120;03011110;Aruana (Osteoglossum bicirrhosum);1;UN
121;03011190;Outros peixes ornamentais, vivos, de agua doce;1;UN
122;03011900;Outros peixes ornamentais vivos;1;UN
123;03019110;Trutas (Salmo trutta e oncorhynchus), para reproducao;1;KG
124;03019190;Outras trutas (Salmo trutta e Oncorhynchus), vivas;1;KG
125;03019210;Enguias (anguilla spp.) para reproducao;1;KG
126;03019290;Outras enguias (anguilla spp.) vivas;1;KG
127;03019310;Carpas para reproducao;1;KG
128;03019390;Outras carpas vivas;1;KG
129;03019410;Albacoras-azuis (Thunnus thynnus) para reproducao;1;KG
130;03019490;Outros albacoras-azuis (Thunnus thynnus) para reproducao;1;KG
131;03019510;Outros peixes para reproducao;1;KG
132;03019590;Outros peixes vivos;1;KG
133;03019911;Tilapias, peixes para reproducao;1;KG
134;03019912;Esturjoes, peixes para reproducao;1;KG
135;03019919;Outros peixes para reproducao;1;KG
136;03019991;Outros peixes tilapias, vivos;1;KG
137;03019992;Outros peixes esturjoes, vivos;1;KG
138;03019999;Outros peixes vivos;1;KG
139;03021100;Trutas frescas, refrigeradas, exceto files, outras carnes, figados, etc;1;KG
140;03021300;Salmoes-do-pacifico (oncorhynchus nerka, etc), fresco ou refrigerado;1;KG
141;03021400;Salmao-do-atlantico e salmao-do-danubio, fresco ou refrigerado;1;KG
142;03021900;Outros salmonideos frescos, refrigerados, exceto files, etc.;1;KG
143;03022100;Linguados-gigantes, frescos, refrig.exceto files, etc.;1;KG
144;03022200;Solhas ou patrucas, frescas, refrigeradas, exceto files, etc.;1;KG
145;03022300;Linguados frescos, refrigerados, exceto files, outras carnes, etc.;1;KG
146;03022400;Pregado (Psetta maxima), fresco ou refrigerado;1;KG
147;03022900;Outros peixes chatos, frescos, refrigerados, exceto files, etc.;1;KG
148;03023100;Atuns-brancos ou germoes, frescos/refrigerados, exceto files, etc;1;KG
149;03023200;Albacoras/atuns barbatana amarela, frescas/refrigerado, exceto files;1;KG
150;03023300;Bonitos-listrados, etc, frescos, refrigerados, exceto files, etc.;1;KG
151;03023400;Albacoras-bandolim (patudos) frescos, refrigerados;1;KG
152;03023500;Albacoras-azuis (atuns-azuis) frescos, refrigerados;1;KG
153;03023600;Atuns do sul frescos ou refrigerados;1;KG
154;03023900;Outros atuns frescos, refrigerados, exceto files, outras carnes, etc.;1;KG
155;03024100;Arenques (Clupea harengus, Clupea pallasii), fresco ou refrigerado;1;KG
156;03024210;Anchoita (Engraulis anchoita), frescas ou refrigeradas;1;KG
157;03024290;Outras anchovas, frescas ou refrigeradas;1;KG
158;03024300;Sardinhas (sardina pilchardus, etc), anchoveta, fresca ou refrigerada;1;KG
159;03024400;Cavalinhas, frescas ou refrigeradas;1;KG
160;03024500;Chicharros (trachurus spp.), frescos ou refrigerados;1;KG
161;03024600;Bijupira (Rachycentron canadum), fresco ou refrigerado;1;KG
162;03024700;Espadarte (Xiphias gladius), frescos ou refrigerados;1;KG
163;03024910;Espadins, marlins, veleiros (Istiophoridae), frescos ou refrigerados;1;KG
164;03024990;Outros peixes frescos ou refrigerados, exceto os files de peixes e outra carne de peixes da posicao 03.04;1;KG
165;03025100;Bacalhau-do-Atlantico, da-Groelandia e do-Pacifico, fresco ou refrigerado;1;KG
166;03025200;Haddock ou lubina (Melanogrammus aeglefinus), fresco ou refrigerado;1;KG
167;03025300;Saithe (Pollachius virens), frescos ou refrigerados;1;KG
168;03025400;Merluzas e abroteas (Merluccius spp., Urophycis spp.), fresco ou refrigerado;1;KG
169;03025500;Merluza-do-alasca (Theragra chalcogramma), fresca ou refrigerada;1;KG
170;03025600;Verdinhos (Micromesistius poutassou, micromesistius australis);1;KG
171;03025900;Outros peixes das familias bregmacerotidae, gadidae, etc.;1;KG
172;03027100;Tilapias (oreochromis spp.), frescas ou refrigeradas;1;KG
173;03027210;Bagre (Ictalurus puntactus), fresco ou refrigerado;1;KG
174;03027290;Outros bagres frescos ou refrigerados;1;KG
175;03027300;Carpas (Cyprinus carpio, Carassius carassius, etc);1;KG
176;03027400;Enguias (anguilla spp.), frescas ou refrigeradas;1;KG
177;03027900;Perca-do-nilo, peixe cabeca-de-serpente, fresco ou refrigerado;1;KG
178;03028100;Cacao e outros tubaroes, frescos ou refrigerados;1;KG
179;03028200;Raias (rajidae), fresca ou refrigerada;1;KG
180;03028310;Merluza negra (dissostichus eleginoides), fresca ou refrigerada;1;KG
181;03028320;Merluza antartica (Dissostichus mawsoni);1;KG
182;03028400;Robalos (Dicentrarchus spp.), fresco ou refrigerado;1;KG
183;03028500;Pargos ou sargos (sparidae), fresco ou refrigerado;1;KG
184;03028910;Pargo (Lutjanus purpureus), frescos ou refrigerados;1;KG
185;03028921;Cherne-poveiro (Polypirion americanus), fresco ou refrigerado;1;KG
186;03028922;Garoupas (acanthistius spp.), fresco ou refrigerado;1;KG
187;03028923;Esturjao (Acipenser baeri), fresco ou refrigerado;1;KG
188;03028924;Peixes-rei (atherina spp.), fresco ou refrigerado;1;KG
189;03028931;Curimatas (prochilodus spp.), fresco ou refrigerado;1;KG
190;03028932;Tilapias (tilapia,sarotherodon,danakilia), seus hibridos;1;KG
191;03028933;Surubins (pseudoplatystoma spp.), frescos ou refrigerados;1;KG
192;03028934;Traira (Hoplias malabaricus & h. cf. lacerdae);1;KG
193;03028935;Piaus (leporinus spp.), fresco ou refrigerado;1;KG
194;03028936;Tainhas (mugil spp), fresco ou refrigerado;1;KG
195;03028937;Pirarucu (Arapaima gigas), fresco ou refrigerado;1;KG
196;03028938;Pescadas (cynocion spp.), fresca ou refrigerada;1;KG
197;03028941;Piramutaba (Brachyplatystoma vaillantii), fresco ou refrigerado;1;KG
198;03028942;Dourada (Brachyplatystoma flavicans), fresco ou refrigerado;1;KG
199;03028943;Pacu (Piaractus mesopotamicus), fr. ou refrig.;1;KG
200;03028944;Tambaqui (Colossoma macropomum);1;KG
201;03028945;Tambacu (hibrido de tambaqui e pacu);1;KG
202;03028990;Outros peixes frescos ou refrigerados;1;KG
203;03029100;Figados, ovas e gonadas masculinas, frescos ou refrigerados;1;KG
204;03029200;Barbatanas de tubarao, frescos ou refrigerados;1;KG
205;03029900;Cabecas, caudas, bexigas-natatorias e outros subprodutos comestiveis de peixes;1;KG
206;03031100;Salmoes vermelhos congelados;1;KG
207;03031200;Outros salmoes-do-pacifico, congelados;1;KG
208;03031300;Salmao-do-atlantico e salmao-do-danubio, congelados;1;KG
209;03031400;Trutas (Salmo trutta, Oncorhynchus mykiss, etc.), congeladas;1;KG
210;03031900;Outros tipos de salmoes, congelados;1;KG
211;03032300;Tilapias (oreochromis spp.), congeladas;1;KG
212;03032410;Bagre (Ictalurus puntactus) congelado;1;KG
213;03032490;Perca-do-nilo e cabecas-de-serpente, congelados;1;KG
214;03032500;Carpas, congeladas;1;KG
215;03032600;Enguias congeladas (anguilla spp.), congeladas;1;KG
216;03032900;Outros salmonideos congelados, exceto files, outras carnes, etc;1;KG
217;03033100;Linguados-gigantes (Reinhardtius hippoglossoides, Hippoglossus hippoglossus, Hippoglossus stenolepis), congelados, exceto files, outras carnes, etc;1;KG
218;03033200;Solha (Pleuronectes platessa), congeladas, exceto files, outras carnes, etc;1;KG
219;03033300;Linguados congelados, exceto files, outras carnes, figados, etc.;1;KG
220;03033400;Pregado (Psetta maxima), congelado;1;KG
221;03033900;Outros peixes chatos, congelados, exceto files, outras carnes, etc;1;KG
222;03034100;Atuns-brancos ou germoes, congelados, exceto files, etc.;1;KG
223;03034200;Albacora-laje (Thunnus albacares), congeladas, exceto files, etc;1;KG
224;03034300;Bonito-listrado, congelados, exceto files, figados, ovas e semen;1;KG
225;03034400;Albacora-bandolim (Thunnus obesus), congelados, exceto files, figados, ovas e semen;1;KG
226;03034500;Atuns azuis (Thunnus thynnus, Thunnus orientalis), congelados, exceto files, figados, ovas e semen;1;KG
227;03034600;Atum azul do Sul (Thunnus maccoyii), congelado, exceto files, figados, ovas e semen;1;KG
228;03034900;Outros atuns congelados, exceto files, outras carnes, figados, etc;1;KG
229;03035100;Arenques, congelados, exceto figado, ovas, semen;1;KG
230;03035300;Sardinhas (Sardina pilchardus, Sardinops spp., Sardinella spp.), anchoveta (Sprattus sprattus), congeladas;1;KG
231;03035400;Cavalinhas (Scomber scombrus, Scomber australasicus, Scomber japonicus), congeladas;1;KG
232;03035500;Chicharros (trachurus spp.), congelados;1;KG
233;03035600;Bijupira (Rachcentron canadum), congelado;1;KG
234;03035700;Espadarte (Xiphias galdius), congelado;1;KG
235;03035910;Espadins, marlins, veleiros (Istiophoridae), congelados;1;KG
236;03035920;Anchoita (Engraulis anchoita), congelado;1;KG
237;03035990;Outros peixes congelados, exceto os files de peixes e outra carne de peixes da posicao 03.04;1;KG
238;03036300;Bacalhau-do-atlantico e bacalhau-do-pacifico, congelado;1;KG
239;03036400;Haddock ou lubina (Melanogrammus aeglefinus), congelado;1;KG
240;03036500;Saithe (Pollachius virens), congelado;1;KG
241;03036600;Merluzas e abroteas (merluccius , urophycis ), congeladas;1;KG
242;03036700;Merluza-do-alasca (Theragra chalcogramma), congelada;1;KG
243;03036800;Verdinhos (Micromesistius poutassou, Micromesistius australis), congelados (exceto files, outras carnes);1;KG
244;03036910;Merluza rosada (Macruronus megellanicus), congelada;1;KG
245;03036990;Outros peixes congelados, exceto file e outras carnes;1;KG
246;03038111;Tubarao-azul (prionace glauca) inteiro, congelado;1;KG
247;03038112;Tubarao-azul, eviscerado, sem cabeca e sem barbatana, congelado;1;KG
248;03038113;Tubarao-azul em pedacos, com pele, congelado;1;KG
249;03038114;Tuabarao-azul em pedacos, sem pele, congelado;1;KG
250;03038119;Outros tubaroes-azuis, congelados;1;KG
251;03038190;Outros tubaroes, congelados;1;KG
252;03038200;Raias (rajidae), congeladas;1;KG
253;03038311;Merluza negra, evisceradas, sem cabeca e sem cauda, congelada;1;KG
254;03038319;Outras partes de merluza negra, congeladas;1;KG
255;03038321;Merluza antartica, evisceradas, sem cabeca e sem cauda, congelada;1;KG
256;03038329;Outras partes de merluza antartica, congeladas;1;KG
257;03038400;Robalos (dicentrarchus spp.), congelados;1;KG
258;03038910;Corvina (Micropogonias furnieri), congelada;1;KG
259;03038920;Pescadas (Cynoscion spp.), congeladas;1;KG
260;03038932;Pargo (Lutjanus purpureus), congelado;1;KG
261;03038933;Peixe-sapo (Lophius gastrophysus), congelado;1;KG
262;03038941;Cherne-poveiro (Polyprion americanus), congelado;1;KG
263;03038942;Garoupas (acanthistius spp.), congeladas;1;KG
264;03038943;Tainhas (mujil spp.), congeladas;1;KG
265;03038944;Esturjoes (acipenser), congelados;1;KG
266;03038945;Peixes-rei (atherina spp.), congelados;1;KG
267;03038946;Nototenias (patagonotothen spp.), congeladas;1;KG
268;03038951;Curimatas (prochilodus spp.), congelados;1;KG
269;03038952;Tilapias (Tilapia spp., Sarotherodon spp., Danakilia spp., seus hibridos), congeladas, exceto files, outras carnes, etc;1;KG
270;03038953;Surubins (congelados), exceto files, outras carnes, etc;1;KG
271;03038954;Traira (Hoplias malabaricus e H. cf. lacerdae) (congeladas), exceto files, outras carnes, etc;1;KG
272;03038955;Piaus (leporinus spp.) congelados;1;KG
273;03038956;Pirarucu (congelado), exceto files, outras carnes, etc;1;KG
274;03038961;Piramutaba (Brachyplatystoma vaillantii), congelado, exceto  files, outras carnes, etc;1;KG
275;03038962;Dourada (Brachyplatystoma flavicans), congeladas, exceto files, outras carnes, etc.;1;KG
276;03038963;Pacu (Piaractus mesopotamicus), congelado, exceto files, outras carnes, etc.;1;KG
277;03038964;Tambaqui (Colossoma macropomum) congelado, exceto files, outras carnes, etc;1;KG
278;03038965;Tambacu (hibrido de tambaqui e pacu), congelado, exceto file, etc;1;KG
279;03038990;Outros peixes congelados, exceto files, outras carnes,etc.;1;KG
280;03039100;Figados, ovas e gonadas masculinas, congelado;1;KG
281;03039200;Barbatanas de tubarao, congelado;1;KG
282;03039910;Cabecas de Merluza negra (Dissostichus eleginoides), congelado;1;KG
283;03039920;Cabecas de Merluza antartica (Dissostichus mawsoni), congelado;1;KG
284;03039990;Outros subprodutos comestiveis de peixes, congelado;1;KG
285;03043100;Files de tilapias (frescos, refrigerados ou conelados);1;KG
286;03043210;Files de bagre (Ictalurus puntactus), frescos, refrigerados ou congelados;1;KG
287;03043290;Files de outros bagres, frescos, refrigerados ou congelados;1;KG
288;03043300;File de perca-do-nilo, fresco, refrigerado ou congelado;1;KG
289;03043900;Files/outras carnes de outros peixes, frescos, refrigerados ou congelados;1;KG
290;03044100;Files de salmoes-do-pacifico e salmao-do-danubio;1;KG
291;03044200;Files de truta (almo trutta, oncorhynchus mykiss, etc);1;KG
292;03044300;Files de peixes chatos (pleuronectidae, soleidae, etc);1;KG
293;03044400;Files de peixes das familias bregmacerotidae, etc;1;KG
294;03044500;Files e outras carnes de espadarte (Xyphias gladius);1;KG
295;03044600;Files de merluza negra e merluza antartica;1;KG
296;03044700;Files de cacao e outros tubaroes, frescos ou refrigerados;1;KG
297;03044800;Files de raias (Rajidae), frescos ou refrigerados;1;KG
298;03044910;File de cherne-poveiro, fresco/refrigerado;1;KG
299;03044920;File de garoupa (Acanthistius spp), fresco/refrigerado;1;KG
300;03044990;Files de outros peixes, frescos ou refrigerados;1;KG
301;03045100;Files de tilapia, bagre, carpa, enguias, fresco ou refrigerado;1;KG
302;03045200;File e outras carnes de salmonideos, fresco ou refrigerado;1;KG
303;03045300;File de peixes de diversas familias;1;KG
304;03045400;File de espadartes (Xiphias gladius), fresco ou refrigerado;1;KG
305;03045500;Files de merluza negra e merluza antartica, fresco ou refrigerado;1;KG
306;03045600;Outras carnes de cacao e outros tubaroes, frescos ou refrigerados;1;KG
307;03045700;Outras carnes de raias (Rajidae), frescos ou refrigerados;1;KG
308;03045900;Outros files de peixes, frescos ou refrigerados;1;KG
309;03046100;Files de tilapias (Oreochromis spp.), congelados;1;KG
310;03046210;Files de bagre (Ictalarus puntactus), congelados;1;KG
311;03046290;Outros files de peixes, congelados;1;KG
312;03046300;File de perca-do-nilo (Lates niloticus), congelado;1;KG
313;03046900;File de peixe cabeca-de-serpente, congelado;1;KG
314;03047100;File de bacalhau do Atlantico, da Groelandia e do Pacifico, congelado;1;KG
315;03047200;File de haddock ou lubina, congelado;1;KG
316;03047300;File de saithe (Pollachius virens), congelado;1;KG
317;03047400;Files de merluzas e abroteas, congelados;1;KG
318;03047500;File de merluza-do-alasca (Theragra chalcogramma), congelado;1;KG
319;03047900;Outros files de peixes, congelados;1;KG
320;03048100;File de salmao-do-pacifico, do-danubio, do-atlantico, congelado;1;KG
321;03048200;Files de trutas, congelados;1;KG
322;03048300;Files de peixes chatos, congelados;1;KG
323;03048400;Files de espadarte (Xiphias gladius), congelados;1;KG
324;03048510;File de merluza negra (Dissostichus eleginoides), congelado;1;KG
325;03048520;File de merluza antartica (Dissostichus mawsoni), congelado;1;KG
326;03048600;Files de arenques (Clupea harengus, Clupea pallasii), congelados;1;KG
327;03048700;Files de atuns e bonito-listrado, congelados;1;KG
328;03048810;Files de tubarao-azul (Prionace glauca), congelados;1;KG
329;03048890;Files de cacao e outros tubaroes, e files de rais (Rajidae), congelado;1;KG
330;03048910;File de pargo (Lutjanus purpureus);1;KG
331;03048920;File de cherne-poveiro (Poluprion americanus), congelado;1;KG
332;03048930;File de garoupa (Acanthistius spp.), congelados;1;KG
333;03048990;Outros files congelados, de peixes;1;KG
334;03049100;Espadartes (Xiphias gladius), frescos, refrigerados, congelados;1;KG
335;03049211;Bochechas (cheeks) de merluza-negra (Dissostichus eleginoides), frescos/refrigerado/congelado;1;KG
336;03049212;Colares de merluza negra (Dissostichus eleginoides), frescos/refrigerado/congelado;1;KG
337;03049219;Outros peixes marlongas-negras, frescos/refrigerados/congelados;1;KG
338;03049221;Bochechas (cheeks) de merluza antartica (Dissostichus mawsoni), frescos, refrigerados ou congelados;1;KG
339;03049222;Colares de peixes merluza antartica (Dissostichus mawsoni), frescos/refrigerado/congelado;1;KG
340;03049229;Outras partes de peixes merluza antartica (Dissostichus mawsoni) frescos/refrigerados/congelados;1;KG
341;03049300;Outras carnes de tilapias, bagres, carpas, enguias, congeladas;1;KG
342;03049400;Outras carnes de merluza-do-alasca, congeladas;1;KG
343;03049500;Outras carnes de peixes de diversas familias;1;KG
344;03049600;Files de cacao e outros tubaroes, frescos, refrigerados ou congelados;1;KG
345;03049700;Files de raias (Rajidae), frescos, refrigerados ou congelados;1;KG
346;03049900;Outras carnes de peixes, frescos, refrigerados ou congelados;1;KG
347;03051000;Farinhas, pos e pellets de peixes, para alimentacao humana;1;KG
348;03052000;Figados, ovas e semen, de peixes, secos, defumados, etc.;1;KG
349;03053100;Files de peixes, secos, salgados, em salmoura, nao defumados;1;KG
350;03053210;Files de bacalhau, secos, salgados, em salmoura, nao defumado;1;KG
351;03053220;Files de saithe, secos, salgados, em salmoura, nao defumados;1;KG
352;03053230;Files de Ling (Molva molva) e zarbo (Brosme brosme), secos, salgados ou em salmoura, mas nao defumados;1;KG
353;03053290;Outros files de peixes, secos, salgados/salmoura, nao defumado;1;KG
354;03053900;Files de outros peixes, secos, salgados ou em salmoura, mas nao defumados;1;KG
355;03054100;Salmoes-do-pacifico, do atlantico e do danubio, defumados;1;KG
356;03054200;Arenques defumados, mesmo em files;1;KG
357;03054300;Truta defumada, mesmo em files;1;KG
358;03054400;Tilapia, bagre, carpa, enguia, defumados, mesmo em files;1;KG
359;03054910;Bacalhaus (gadus) defumados, mesmo em files;1;KG
360;03054920;Saithes (Polachius virens), lings e zarbos (Brosme brosme);1;KG
361;03054990;Outros peixes defumados, mesmo em files;1;KG
362;03055100;Bacalhaus (gadus) secos, mesmo salgados, mas nao defumados;1;KG
363;03055200;Peixes secos, exceto subprodutos comestiveis de peixes, mesmo salgados, mas nao defumados: tilapias, bagres, carpas, perca-do-nilo e peixes cabeca-de-serpente;1;KG
364;03055310;Bacalhau polar(Boreogadus saida),saithe (Pollachius virens), ling (Molva molva),ling azul (Molva dypterygia),zarbo (Brosme brosme),abrotea-do-alto (Urophycis blennoides) e haddock ou lubina (Melanogrammus aeglefinus),secos,mesmo salgados,mas nao defumados;1;KG
365;03055390;Outros peixes secos, exceto subprodutos comestiveis de peixes, mesmo salgados, mas nao defumados (fumados);1;KG
366;03055400;Peixes secos, exceto subprodutos comestiveis de peixes, mesmo salgados, mas nao defumados: arenques, sardinhas e sardinelas, anchoveta, cavalinhas, cavalas-do-indico, serras, carapaus, xareus, bijupira, pampos-prateado, agulhao-do-japao, charros, etc.;1;KG
367;03055900;Outros peixes secos, exceto subprodutos comestiveis de peixes, mesmo salgados, mas nao defumados;1;KG
368;03056100;Arenques (Clupea harengus, Clupea pallasii) salgados, nao secos, nao defumados e em salmoura;1;KG
369;03056200;Bacalhau-do-atlantico (Gadus mohrua), bacalhau-da-groelandia (Gadus ogac) e bacalhau-do-pacifico (Gadus macrocephalus) salgados, nao secos, nao defumados, salmoura;1;KG
370;03056300;Anchovas salgadas, nao secas, nao defumadas e em salmoura;1;KG
371;03056400;Tilapias, bagre, carpas, enguia, salgado, nao seco, nao defumado;1;KG
372;03056910;Saithe (Pollachius virens), ling (Molva molva) e zarbo (Brosme brosme);1;KG
373;03056990;Outros peixes salgados nao secos, nao defumado e em salmoura;1;KG
374;03057100;Barbatanas de tubarao;1;KG
375;03057200;Cabecas, caudas e bexigas natatorias, de peixes;1;KG
376;03057900;Outros desperdicios comestiveis, de peixes;1;KG
377;03061110;Lagostas (Palinurus spp., Panulirus spp., Jasus spp.) inteiras, congeladas;1;KG
378;03061190;Outras lagostas (Palinurus spp., Panulirus spp., Jasus spp.), congeladas, exceto as inteiras;1;KG
379;03061200;Lavagantes (Homarus spp.), congelados;1;KG
380;03061400;Caranguejos congelados;1;KG
381;03061500;Lagosta norueguesa (nephrops norvegicus);1;KG
382;03061610;Camaroes de agua fria (pandalus spp.) inteiros, congelados;1;KG
383;03061690;Camaroes de agua fria, que nao inteiros, congelados;1;KG
384;03061710;Outros camaroes inteiros, congelados;1;KG
385;03061790;Outros camaroes, que nao inteiros, congelados;1;KG
386;03061910;Krill (Euphausia superba), congelado;1;KG
387;03061990;Outros crustaceos congelados, inclusive farinhas, etc, para alimentacao humana;1;KG
388;03063100;Lagostas (Palinurus spp., Panulirus spp., Jasus spp.), vivas, frescos ou refrigerados;1;KG
389;03063200;Lavagantes (Homarus spp.), vivos, frescos ou refrigerados;1;KG
390;03063300;Caranguejos vivos, frescos ou refrigerados;1;KG
391;03063400;Lagosta norueguesa (Lagostim) (Nephrops norvegicus), viva, frescos ou refrigerados;1;KG
392;03063500;Camaroes de agua fria (Pandalus spp., Crangon crangon), vivos, frescos ou refrigerados;1;KG
393;03063600;Outros camaroes, vivos, frescos ou refrigerados;1;KG
394;03063910;Lagosta de agua doce (Cherax quadricarinatus), vivo, fresco ou refrigerado;1;KG
395;03063990;Outros, incluindo as farinhas, pos e pellets de crustaceos, proprios para alimentacao humana;1;KG
396;03069100;Lagostas (Palinurus spp., Panulirus spp., Jasus spp.);1;KG
397;03069200;Lavagantes (Homarus spp.);1;KG
398;03069300;Caranguejos;1;KG
399;03069400;Lagosta norueguesa (Lagostim) (Nephrops norvegicus);1;KG
400;03069500;Camaroes;1;KG
401;03069910;Lagosta de agua doce (Cherax quadricarinatus);1;KG
402;03069990;Outros crustaceos, incluindo as farinhas, pos e pellets de crustaceos, proprios para alimentacao humana;1;KG
403;03071100;Ostras vivas, frescas ou refrigeradas;1;KG
404;03071200;Ostras, congeladas;1;KG
405;03071900;Outras ostras vivas;1;KG
406;03072100;Vieiras e outros mariscos dos generos Pecten, Chlamys ou Placopecten, vivos, frescos ou refrigerados;1;KG
407;03072200;Vieiras, incluindo a americana, e outros moluscos dos generos Pecten, Chlamys ou Placopecten, congeladas;1;KG
408;03072900;Vieiras e outros mariscos dos generos Pecten, Chlamys ou Placopecten, congelados, secos, etc;1;KG
409;03073100;Mexilhoes (Mytilus spp., Perna spp.), vivos, frescos, refrigerados;1;KG
410;03073200;Mexilhoes (Mytilus spp., Perna spp.), congelados;1;KG
411;03073900;Mexilhoes (Mytilus spp., Perna spp.), congelados, secos, salgados, etc;1;KG
412;03074200;Sepias (Chocos) (Chocos e chopos), lulas (potas e lulas), vivas, frescas ou refrigeradas;1;KG
413;03074310;Lulas, congeladas;1;KG
414;03074320;Sepias, congeladas;1;KG
415;03074900;Outras sepias (Chocos) (Chocos e chopos), lulas (potas e lulas);1;KG
416;03075100;Polvos (Octopus spp) vivos, frescos ou refrigerados;1;KG
417;03075200;Polvos (Octopus spp.), congelados;1;KG
418;03075900;Polvos (Octopus spp.) em outra forma que nao vivos, frescos, refrigerados ou congelados;1;KG
419;03076000;Caracois, exceto os do mar, vivos, frescos, refrigerados, etc.;1;KG
420;03077100;Ameijoas, berbigoes e arcas (familias Arcidae, Arcticidae, Cardiidae, Donacidae, Hiatellidae, Mactridae, Mesodesmatidae, Myidae, Semelidae, Solecurtidae, Solenidae, Tridacnidae e Veneridae), vivos, frescos ou refrigerados;1;KG
421;03077200;Ameijoas, berbigoes e arcas (familias Arcidae, Arcticidae, Cardiidae, Donacidae, Hiatellidae, Mactridae, Mesodesmatidae, Myidae, Semelidae, Solecurtidae, Solenidae, Tridacnidae e Veneridae), congelados;1;KG
422;03077900;Ameijoas, berbigoes e arcas (familias Arcidae, Arcticidae, Cardiidae, Donacidae, Hiatellidae, Mactridae, Mesodesmatidae, Myidae, Semelidae, Solecurtidae, Solenidae, Tridacnidae e Veneridae), em outras formas;1;KG
423;03078100;Abalones (Haliotis spp.), vivos, frescos ou refrigerados;1;KG
424;03078200;Estrombos (Strombus spp.) vivos, frescos ou refrigerados;1;KG
425;03078300;Abalones (Orelhas-do-mar) (Haliotis spp.) congelados;1;KG
426;03078400;Estrombos (Strombus spp.) congelados;1;KG
427;03078700;Outros abalones (Outras orelhas-do-mar) (Haliotis spp.);1;KG
428;03078800;Outros estrombos (Strombus spp.);1;KG
429;03079100;Outros moluscos, invertebrados aquaticos, vivos, frescos, refrigerados;1;KG
430;03079200;Outros moluscos, incluindo as farinhas, pos e pellets, proprios para alimentacao humana, congelados;1;KG
431;03079900;Outros moluscos, invertebrados aquaticos, congelados, secos;1;KG
432;03081100;Pepinos-do-mar (Stichopus japonicus, Holothurioidea), vivos, frescos ou refrigerados;1;KG
433;03081200;Pepinos-do-mar (Stichopus japonicus, Holothuroidea), congelados;1;KG
434;03081900;Pepinos-do-mar (Stichopus japonicus, Holothurioidea), em outras formas;1;KG
435;03082100;Ouricos-do-mar (Strongylocentrotus spp., Paracentrotus lividus, Loxechinus albus, Echichinus esculentus), vivos, frescos ou refrigerados;1;KG
436;03082200;Ouricos-do-mar (Strongylocentrotus spp., Paracentrotus lividus, Loxechinus albus, Echinus esculentus), congelados;1;KG
437;03082900;Ouricos-do-mar (Strongylocentrotus spp., Paracentrotus lividus, Loxechinus albus, Echichinus esculentus), em outras formas;1;KG
438;03083000;Medusas (aguas-vivas) (rhopilema spp.);1;KG
439;03089000;Outros invertebrados aquaticos, exceto crustaceos e moluscos, congelado, seco, etc;1;KG
440;04011010;Leite UHT (Ultra High Temperature), com um teor, em peso, de materias gordas, nao superior a 1 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
441;04011090;Outros leites e cremes, com um teor, em peso, de materias gordas, nao superior a 1 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
442;04012010;Leite UHT (Ultra High Temperature), com um teor, em peso, de materias gordas, superior a 1 %, mas nao superior a 6 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
443;04012090;Outros leites e cremes, com um teor, em peso, de materias gordas, superior a 1 %, mas nao superior a 6 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
444;04014010;Leite, com um teor, em peso, de materias gordas, superior a 6 %, mas nao superior a 10 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
445;04014021;Creme de leite UHT (Ultra High Temperature), com um teor, em peso, de materias gordas, superior a 6 %, mas nao superior a 10 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
446;04014029;Outros cremes de leite, com um teor, em peso, de materias gordas, superior a 6 %, mas nao superior a 10 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
447;04015010;Leite, com um teor, em peso, de materias gordas, superior a 10 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
448;04015021;Creme de leite UHT (Ultra High Temperature), com um teor, em peso, de materias gordas, superior a 10 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
449;04015029;Outros cremes de leite, com um teor, em peso, de materias gordas, superior a 10 %, nao concentrados nem adicionados de acucar ou de outros edulcorantes;1;KG
450;04021010;Leite em po, granulos ou outras formas solidas, com um teor, em peso, de materias gordas, nao superior a 1,5 %, com um teor de arsenio, chumbo ou cobre, considerados isoladamente,inferior a 5 ppm, concentrados ou adicionados de acucar/outros edulcorantes.;1;KG
451;04021090;Outros leites e cremes, em po, com um teor, em peso, de materias gordas, nao superior a 1,5 %, concentrados ou adicionados de acucar ou de outros edulcorantes;1;KG
452;04022110;Leite integral, em po, com um teor, em peso, de materias gordas, superior a 1,5 %, sem adicao de acucar ou de outros edulcorantes;1;KG
453;04022120;Leite parcialmente desnatado, em po, com um teor, em peso, de materias gordas, superior a 1,5 %, sem adicao de acucar ou de outros edulcorantes;1;KG
454;04022130;Creme de leite, em po, com um teor, em peso, de materias gordas, superior a 1,5 %, sem adicao de acucar ou de outros edulcorantes;1;KG
455;04022910;Leite integral, em po, etc, com um teor, em peso, de materias gordas, superior a 1,5 %, adocicado;1;KG
456;04022920;Leite parcialmente desnatado, em po, com um teor, em peso, de materias gordas, superior a 1,5 %, adocicado;1;KG
457;04022930;Creme de leite, em po, etc. com um teor, em peso, de materias gordas, superior a 1,5 %, adocicado;1;KG
458;04029100;Outros leites, cremes de leite, concentrados, sem adicao de acucar ou de outros edulcorantes;1;KG
459;04029900;Outros leites, cremes de leite, concentrados, adocicados;1;KG
460;04031000;Iogurte;1;KG
461;04039000;Leitelho, leite, creme de leite, coalhados, fermentados, etc;1;KG
462;04041000;Soro de leite, modificado ou nao, mesmo concentrado ou adicionado de acucar ou de outros edulcorantes;1;KG
463;04049000;Outros produtos constituidos do leite, mesmo adocicados, etc;1;KG
464;04051000;Manteiga;1;KG
465;04052000;Pasta de espalhar (pasta de barrar) de produtos provenientes do leite;1;KG
466;04059010;Oleo butirico de manteiga (butter oil);1;KG
467;04059090;Outras materias gordas provenientes do leite;1;KG
468;04061010;Queijo tipo mussarela, fresco (nao curado);1;KG
469;04061090;Outros queijos frescos (nao curados), inclusive requeijao, etc.;1;KG
470;04062000;Queijos ralados ou em po, de qualquer tipo;1;KG
471;04063000;Queijos fundidos, exceto ralados ou em po;1;KG
472;04064000;Queijos de pasta mofada e outros queijos que apresentem veios obtidos utilizando Penicillium roqueforti;1;KG
473;04069010;Queijos, com um teor de umidade inferior a 36,0 %, em peso (massa dura);1;KG
474;04069020;Queijos, com um teor de umidade superior ou igual a 36,0 % e inferior a 46,0 %, em peso (massa semidura);1;KG
475;04069030;Queijos, com um teor de umidade superior ou igual a 46,0 % e inferior a 55,0 %, em peso (massa macia);1;KG
476;04069090;Outros queijos;1;KG
477;04071100;Ovos fertilizados destinados a incubacao, de aves da especie Gallus domesticus;1;DUZIA
478;04071900;Ovos fertilizados destinados a incubacao, de outras aves;1;DUZIA
479;04072100;Outros ovos frescos de aves da especie Gallus domesticus;1;DUZIA
480;04072900;Ovos frescos de outras aves;1;DUZIA
481;04079000;Ovos de outras aves, nao para incubacao ou nao frescos;1;KG
482;04081100;Gemas de ovos, secas;1;KG
483;04081900;Gemas de ovos, frescas, cozidas em agua ou vapor, etc.;1;KG
484;04089100;Ovos de aves, sem casca, secos;1;KG
485;04089900;Outros ovos de aves, sem casca, frescos, cozidos em agua, etc;1;KG
486;04090000;Mel natural;1;KG
487;04100000;Produtos comestiveis de origem animal, nao especificados nem compreendidos noutras posicoes;1;KG
488;05010000;Cabelos em bruto, mesmo lavados ou desengordurados, desperdicios de cabelo;1;KG
489;05021011;Cerdas de porco, lavadas, alvejadas ou desengorduradas, mesmo tintas;1;KG
490;05021019;Outras cerdas de porco e seus desperdicios;1;KG
491;05021090;Cerdas de javali e seus desperdicios;1;KG
492;05029010;Pelos de texugo e outros pelos para escovas, pinceis e artigos semelhantes;1;KG
493;05029020;Desperdicios de pelos;1;KG
494;05040011;Tripas de bovinos, frescos, refrigerados, congelados, salgados ou em salmoura, secos ou defumados;1;KG
495;05040012;Tripas de ovinos, frescos, refrigerados, congelados, salgados ou em salmoura, secos ou defumados;1;KG
496;05040013;Tripas de suinos, frescos, refrigerados, congelados, salgados ou em salmoura, secos ou defumados;1;KG
497;05040019;Tripas de outros animais (exceto peixes), frescos, refrigerados, congelados, salgados ou em salmoura, secos ou defumados;1;KG
498;05040090;Bexigas e estomagos, de animais, exceto peixes, frescas, etc.;1;KG
499;05051000;Penas dos tipos utilizados para enchimento ou estofamento, penugem;1;KG
500;05059000;Peles e outras partes de aves, com suas penas, penugem, etc.;1;KG
501;05061000;Osseina e ossos acidulados;1;KG
502;05069000;Outros ossos e nucleos corneos, em bruto, desengordurado, etc.;1;KG
503;05071000;Marfim, po e desperdicios de marfim;1;KG
504;05079000;Carapacas de tartarugas, chifres, galhadas, cascos, etc.;1;KG
505;05080000;Coral e materias semelhantes, em bruto ou simplesmente preparados, mas nao trabalhados de outro modo, conchas e carapacas de moluscos, crustaceos ou de equinodermes e ossos de sepias, em bruto ou simplesmente preparados, etc.;1;KG
506;05100010;Pancreas de bovinos, utilizadas na preparacao de produtos farmaceuticos, frescas, refrigeradas, congeladas ou provisoriamente conservadas de outro modo;1;KG
507;05100090;Outras substancias de animais, para preparacao de produtos farmaceuticos;1;KG
508;05111000;Semen de bovino;1;G
509;05119110;Ovas de peixe fecundadas, para reproducao;1;KG
510;05119190;Outros produtos de peixes, etc, improprios para alimentacao humana;1;KG
511;05119910;Embrioes de animais;1;KG
512;05119920;Semen animal;1;KG
513;05119930;Ovos de bicho-da-seda;1;KG
514;05119991;Crinas e seus desperdicios, mesmo em mantas, com ou sem suportes;1;KG
515;05119999;Outros produtos de origem animal, improprios para alimentacao humana;1;KG
516;06011000;Bulbos, tuberculos, raizes tuberosas, rebentos e rizomas, em repouso vegetativo;1;UN
517;06012000;Bulbos, tuberculos, raizes tuberosas, rebentos e rizomas, em vegetacao ou em flor, mudas, plantas e raizes de chicoria;1;UN
518;06021000;Estacas nao enraizadas e enxertos;1;UN
519;06022000;Arvores, arbustos e silvados, de frutos comestiveis, enxertados ou nao;1;UN
520;06023000;Rododendros e azaleias, enxertados ou nao;1;UN
521;06024000;Roseiras, enxertadas ou nao;1;UN
522;06029010;Micelios de cogumelos;1;KG
523;06029021;Mudas de plantas ornamentais orquideas;1;UN
524;06029029;Mudas de outras plantas ornamentais;1;UN
525;06029081;Mudas de cana-de-acucar;1;UN
526;06029082;Mudas de videira;1;UN
527;06029083;Mudas de cafe;1;UN
528;06029089;Mudas de outras plantas;1;UN
529;06029090;Outras plantas vivas;1;UN
530;06031100;Rosas e seus botoes, cortados para buques, ornamentais frescos;1;DUZIA
531;06031200;Cravos e seus botoes, cortados para buques, ornamentais, frescos;1;DUZIA
532;06031300;Orquideas e seus botoes, cortadas para buques, ornamentais frescos;1;DUZIA
533;06031400;Crisantemos e seus botoes, cortados para buques, ornamentais frescos;1;DUZIA
534;06031500;Lirios (lilium spp.);1;DUZIA
535;06031900;Outros flores e seus botoes, cortados para buques, ornamentais frescos;1;DUZIA
536;06039000;Flores e seus botoes, secos, etc, cortados para buques, etc.;1;KG
537;06042000;Folhagem, folhas, ramos e outras partes de plantas, sem flores nem botoes de flores, e ervas, musgos e liquenes, para buques ou para ornamentacao, frescos, secos, branqueados, tingidos, impregnados ou preparados de outro modo, frescos;1;KG
538;06049000;Outras folhagens, folhas, ramos e outras partes de plantas, sem flores nem botoes de flores, e ervas, musgos e liquenes, para buques ou para ornamentacao, frescos, secos, branqueados, tingidos, impregnados ou preparados de outro modo;1;KG
539;07011000;Batatas, frescas ou refrigeradas, para semeadura;1;KG
540;07019000;Batatas, frescas ou refrigeradas, exceto para semeadura;1;KG
541;07020000;Tomates, frescos ou refrigerados;1;KG
542;07031011;Cebolas, frescas ou refrigeradas, para semeadura;1;KG
543;07031019;Cebolas, frescas ou refrigeradas, exceto para semeadura;1;KG
544;07031021;Chalotas, frescas ou refrigeradas, para semeadura;1;KG
545;07031029;Chalotas, frescas ou refrigeradas, exceto para semeadura;1;KG
546;07032010;Alhos, frescos ou refrigerados, para semeadura;1;KG
547;07032090;Alhos, frescos ou refrigerados, exceto para semeadura;1;KG
548;07039010;Alhos-porros e outros produtos horticolas aliaceos, frescos ou refrigerados, para semeadura;1;KG
549;07039090;Alhos-porros e outros produtos horticolas aliaceos, frescos ou refrigerados, exceto para semeadura;1;KG
550;07041000;Couve-flor e brocolis, frescos ou refrigerados;1;KG
551;07042000;Couve-de-bruxelas, fresca ou refrigerada;1;KG
552;07049000;Couves, repolho, etc, do genero Brassica, frescos ou refrigerados;1;KG
553;07051100;Alfaces repolhudas, frescas ou refrigeradas;1;KG
554;07051900;Outras alfaces frescas ou refrigeradas;1;KG
555;07052100;Chicorias Endivia (Cichorium intybus var. foliosum), frescas ou refrigeradas;1;KG
556;07052900;Outras chicorias, frescas ou refrigeradas;1;KG
557;07061000;Cenouras e nabos, frescos ou refrigerados;1;KG
558;07069000;Beterrabas, rabanetes e outras raizes, frescas, refrigeradas;1;KG
559;07070000;Pepinos e pepininhos (cornichons), frescos ou refrigerados;1;KG
560;07081000;Ervilhas (Pisum sativum), frescas ou refrigeradas;1;KG
561;07082000;Feijoes (vigna, phaseolus spp) frescos ou refrigerados;1;KG
562;07089000;Outros legumes de vagem, frescos ou refrigerados;1;KG
563;07092000;Aspargos frescos ou refrigerados;1;KG
564;07093000;Berinjelas frescas ou refrigeradas;1;KG
565;07094000;Aipo fresco ou refrigerado, exceto aipo-rabano;1;KG
566;07095100;Cogumelos frescos ou refrigerados;1;KG
567;07095900;Outros cogumelos frescos ou refrigerados;1;KG
568;07096000;Pimentoes e pimentas dos generos Capsicum ou Pimenta, frescos ou refrigerados;1;KG
569;07097000;Espinafres, espinafres-da-nova-zelandia e espinafres gigantes, frescos ou refrigerados;1;KG
570;07099100;Alcachofras, frescas ou refrigeradas;1;KG
571;07099200;Azeitonas, frescas ou refrigeradas;1;KG
572;07099300;Aboboras, abobrinhas e cabacas, fresca ou refrigerada;1;KG
573;07099911;Milho doce, frescos ou refrigerados, para semeadura;1;KG
574;07099919;Milho doce, frescos ou refrigerados, exceto para semeadura;1;KG
575;07099990;Outros produtos horticolas, frescos ou refrigerados;1;KG
576;07101000;Batatas, nao cozidas ou cozidas em agua ou vapor, congeladas;1;KG
577;07102100;Ervilhas, nao cozidas ou cozidas em agua ou vapor, congeladas;1;KG
578;07102200;Feijoes (Vigna spp., Phaseolus spp.), nao cozidos ou cozidos em agua ou vapor, congelados.;1;KG
579;07102900;Outros legumes de vagem, nao cozidos ou cozidos em agua ou vapor, congelados;1;KG
580;07103000;Espinafres, espinafres-da-nova-zelandia e espinafres gigantes, nao cozidos ou cozidos em agua ou vapor, congelados;1;KG
581;07104000;Milho doce congelado, nao cozidos ou cozidos em agua ou vapor, congelados;1;KG
582;07108000;Outros produtos horticolas congelados, nao cozidos ou cozidos em agua ou vapor, congelados;1;KG
583;07109000;Misturas de produtos horticolas, nao cozidos ou cozidos em agua ou vapor, congelados;1;KG
584;07112010;Azeitonas conservadas com agua salgada;1;KG
585;07112020;Azeitonas conservadas com agua sulfurada/adicionada de outras substancias;1;KG
586;07112090;Outras azeitonas conservadas transitoriamente;1;KG
587;07114000;Pepinos e pepininhos conservados em agua salgada, etc.;1;KG
588;07115100;Cogumelos agaricus conservado agua salgada, etc.;1;KG
589;07115900;Outros cogumelos e trufas conservados em agua salgada, etc;1;KG
590;07119000;Outros produtos horticolas/misturas, conservados em agua salgada, etc;1;KG
591;07122000;Cebolas secas, inclusive pedacos, fatias, po, etc. sem qualquer outra preparacao;1;KG
592;07123100;Cogumelos do genero Agaricus, secos, mesmo cortados, etc.;1;KG
593;07123200;Orelhas-de-judas (Auricularia spp.), secos, mesmo cortados, etc.;1;KG
594;07123300;Tremelas (Tremella spp.), secos, mesmo cortados, etc.;1;KG
595;07123900;Outros cogumelos e trufas, secos, mesmo cortados, etc.;1;KG
596;07129010;Alho comum em po sem qualquer outro preparo;1;KG
597;07129090;Outros produtos horticolas, misturas de produtos horticolas, secos, inclusive pedacos, fatias, etc;1;KG
598;07131010;Ervilhas (Pisum sativum), secos, em grao, mesmo pelados ou partidos, para semeadura;1;KG
599;07131090;Outras ervilhas (Pisum sativum), secos, em grao, mesmo pelados ou partidos;1;KG
600;07132010;Grao-de-bico, seco, para semeadura;1;KG
601;07132090;Outros graos-de-bico, secos;1;KG
602;07133110;Feijoes (vigna mungo ou radiata) secos, para semeadura;1;KG
603;07133190;Outros feijoes (vigna mungo ou radiata), secos, em graos;1;KG
604;07133210;Feijao-adzuki (Phaseolus ou Vigna angularis), seco, para semeadura;1;KG
605;07133290;Outros feijoes adzuki (Phaseolus ou Vigna angularis), secos, em graos;1;KG
606;07133311;Feijao comum ((Phaseolus vulgaris), preto, seco, para semeadura;1;KG
607;07133319;Outros feijoes comuns, pretos, secos, em graos;1;KG
608;07133321;Feijao comum, branco, seco, para semeadura;1;KG
609;07133329;Outros feijoes comuns, brancos, secos, em graos;1;KG
610;07133391;Outros feijoes comuns, secos, para semeadura;1;KG
611;07133399;Outros feijoes comuns, secos, em graos;1;KG
612;07133410;Feijao-bambara (Vigna subterranea ou Voandzeia subterranea), para semeadura;1;KG
613;07133490;Feijao-bambara (Vigna subterranea ou Voandzeia subterranea), exceto para semeadura;1;KG
614;07133510;Feijao-fradinho (Vigna unguiculata), para semeadura;1;KG
615;07133590;Feijao-fradinho, exceto para semeadura;1;KG
616;07133910;Outros feijoes (Vigna ou Phaseolus), secos, para semeadura;1;KG
617;07133990;Outros feijoes (Vigna ou Phaseolus), secos, em graos;1;KG
618;07134010;Lentilhas secas, para semeadura;1;KG
619;07134090;Outras lentilhas secas, em graos;1;KG
620;07135010;Favas (Vicia faba var. major) e fava forrageira (Vicia faba var. equina, Vicia faba var. minor), secas, para semeadura;1;KG
621;07135090;Outras favas (Vicia faba var. major) e fava forrageira (Vicia faba var. equina, Vicia faba var. minor), secas, em graos;1;KG
622;07136010;Feijao-guando (Cajanus cajan), para semeadura;1;KG
623;07136090;Feijao-guando (Cajanus cajan), exceto para semeadura;1;KG
624;07139010;Outros legumes de vagem, secos, em graos, para semeadura;1;KG
625;07139090;Outros legumes de vagem, secos, em graos;1;KG
626;07141000;Raizes de mandioca, frescas, refrigeradas, congeladas ou secas;1;KG
627;07142000;Batatas-doces, frescas, refrigeradas, congeladas ou secas;1;KG
628;07143000;Inhames (Dioscorea spp.);1;KG
629;07144000;Taros (Colocasia spp.);1;KG
630;07145000;Mangaritos (Xanthosomo spp.);1;KG
631;07149000;Outras raizes, tuberculos, frescos, etc, e medula de sagueiro;1;KG
632;08011100;Cocos, frescos ou secos, dessecados;1;KG
633;08011200;Cocos na casca interna (endocarpo);1;KG
634;08011900;Cocos frescos;1;KG
635;08012100;Castanha-do-para, fresca ou seca, com casca;1;KG
636;08012200;Castanha-do-para, fresca ou seca, sem casca;1;KG
637;08013100;Castanha de caju, fresca ou seca, com casca;1;KG
638;08013200;Castanha de caju, fresca ou seca, sem casca;1;KG
639;08021100;Amendoas frescas ou secas, com casca;1;KG
640;08021200;Amendoas frescas ou secas, sem casca;1;KG
641;08022100;Avelas (Corylus spp) frescas ou secas, com casca;1;KG
642;08022200;Avelas (Corylus spp) frescas ou secas, sem casca;1;KG
643;08023100;Nozes frescas ou secas, com casca;1;KG
644;08023200;Nozes frescas ou secas, sem casca;1;KG
645;08024100;Castanhas (Castaneas spp.) com casca, frescas ou secas;1;KG
646;08024200;Castanhas (Castaneas spp.), sem casca, frescas ou secas;1;KG
647;08025100;Pistacios, com casca, frescos ou secos;1;KG
648;08025200;Pistacios, sem casca, frescos ou secos;1;KG
649;08026100;Nozes de macadamia, com casca, frescas ou secas;1;KG
650;08026200;Nozes de macadamia, sem casca, frescas ou secas;1;KG
651;08027000;Nozes de cola (Cola spp.), frescas ou secas;1;KG
652;08028000;Nozes de areca (nozes de betele), frescas ou secas;1;KG
653;08029000;Outras frutas de casca rija, frescas ou secas;1;KG
654;08031000;Bananas-da-terra, frescas ou secas;1;KG
655;08039000;Bananas frescas ou secas, exceto bananas-da-terra;1;KG
656;08041010;Tamaras frescas;1;KG
657;08041020;Tamaras secas;1;KG
658;08042010;Figos frescos;1;KG
659;08042020;Figos secos;1;KG
660;08043000;Abacaxis frescos ou secos;1;KG
661;08044000;Abacates frescos ou secos;1;KG
662;08045010;Goiabas frescas ou secas;1;KG
663;08045020;Mangas frescas ou secas;1;KG
664;08045030;Mangostoes frescos ou secos;1;KG
665;08051000;Laranjas, frescas ou secas;1;KG
666;08052100;Mandarinas (incluindo as tangerinas e as satsumas);1;KG
667;08052200;Clementinas;1;KG
668;08052900;Outros citros hibridos;1;KG
669;08054000;Toranjas e pomelos, frescos ou secos;1;KG
670;08055000;Limoes (Citrus limon, Citrus limonum) e limas (Citrus aurantifolia, Citrus latifolia), frescos ou secos;1;KG
671;08059000;Outros citricos frescos ou secos;1;KG
672;08061000;Uvas frescas;1;KG
673;08062000;Uvas secas (passas);1;KG
674;08071100;Melancias frescas;1;KG
675;08071900;Meloes frescos;1;KG
676;08072000;Mamoes (papaias) frescos;1;KG
677;08081000;Macas frescas;1;KG
678;08083000;Peras, frescas;1;KG
679;08084000;Marmelos, frescos;1;KG
680;08091000;Damascos frescos;1;KG
681;08092100;Cerejas-acidas (Prunus cerasus), frescas;1;KG
682;08092900;Outras cerejas, frescas;1;KG
683;08093010;Pessegos, excluindo as nectarinas, frescos;1;KG
684;08093020;Nectarinas, frescas;1;KG
685;08094000;Ameixas e abrunhos, frescos;1;KG
686;08101000;Morangos frescos;1;KG
687;08102000;Framboesas, amoras, incluindo as silvestres, e amoras-framboesas, frescas;1;KG
688;08103000;Groselhas, inclusive o cassis, frescas;1;KG
689;08104000;Airelas, mirtilos e outras frutas do genero Vaccinium, frescas;1;KG
690;08105000;Kiwis (quivis), frescos;1;KG
691;08106000;Durioes (duriangos), frescos;1;KG
692;08107000;Caquis (diospiros), frescos;1;KG
693;08109000;Outras frutas frescas;1;KG
694;08111000;Morangos, nao cozidos ou cozidos em agua ou vapor, congelados, mesmo adicionados de acucar ou de outros edulcorantes;1;KG
695;08112000;Framboesas, amoras, incluindo as silvestres, amoras-framboesas e groselhas, nao cozidas ou cozidas em agua ou vapor, congeladas, mesmo adicionadas de acucar ou de outros edulcorantes;1;KG
696;08119000;Outras frutas nao cozidas ou cozidas em agua ou vapor, congeladas, mesmo adicionadas de acucar ou de outros edulcorantes;1;KG
697;08121000;Cerejas conservadas transitoriamente (por exemplo, com gas sulfuroso ou agua salgada, sulfurada ou adicionada de outras substancias destinadas a assegurar transitoriamente a sua conservacao), mas improprias para alimentacao nesse estado;1;KG
698;08129000;Outras frutas conservadas transitoriamente (por exemplo, com gas sulfuroso ou agua salgada, sulfurada ou adicionada de outras substancias destinadas a assegurar transitoriamente a sua conservacao), mas improprias para alimentacao nesse estado;1;KG
699;08131000;Damascos secos;1;KG
700;08132010;Ameixas secas, com caroco;1;KG
701;08132020;Ameixas secas, sem caroco;1;KG
702;08133000;Macas secas;1;KG
703;08134010;Peras secas;1;KG
704;08134090;Outras frutas secas;1;KG
705;08135000;Misturas de frutas secas ou de frutas de casca rija, do presente Capitulo;1;KG
706;08140000;Cascas de frutos citricos, de meloes ou de melancias, frescas, secas, congeladas ou apresentadas em agua salgada, sulfurada ou adicionada de outras substancias destinadas a assegurar transitoriamente a sua conservacao;1;KG
707;09011110;Cafe nao torrado, nao descafeinado, em grao;1;TON
708;09011190;Cafe nao torrado, nao descafeinado, exceto em grao;1;KG
709;09011200;Cafe nao torrado, descafeinado;1;KG
710;09012100;Cafe torrado, nao descafeinado;1;KG
711;09012200;Cafe torrado, descafeinado;1;KG
712;09019000;Cascas, peliculas de cafe e sucedaneos do cafe;1;KG
713;09021000;Cha verde (nao fermentado) em embalagens imediatas de conteudo nao superior a 3 kg;1;KG
714;09022000;Cha verde (nao fermentado) apresentado de qualquer outra forma;1;KG
715;09023000;Cha preto (fermentado) e cha parcialmente fermentado, em embalagens imediatas de conteudo nao superior a 3 kg;1;KG
716;09024000;Cha preto (fermentado) e cha parcialmente fermentado, apresentados de qualquer outra forma;1;KG
717;09030010;Mate simplesmente cancheado;1;KG
718;09030090;Outros tipos de mate;1;KG
719;09041100;Pimenta (do genero Piper), nao triturada nem em po;1;KG
720;09041200;Pimenta (do genero Piper), triturada ou em po;1;KG
721;09042100;Pimentoes e pimentas dos generos Capsicum ou Pimenta, secos, nao triturados nem em po;1;KG
722;09042200;Pimentoes e pimentas dos generos Capsicum ou Pimenta, triturados ou em po;1;KG
723;09051000;Baunilha, nao triturada nem em po;1;KG
724;09052000;Baunilha, triturada ou em po;1;KG
725;09061100;Canela (Cinnamomum zeylanicum blume) e flores de caneleira, nao trituradas nem em po;1;KG
726;09061900;Outras canela e flores de caneleira, nao trituradas nem em po;1;KG
727;09062000;Canela e flores de caneleira, trituradas ou em po;1;KG
728;09071000;Cravo-da-india (frutos, flores e pedunculos), nao triturado nem em po;1;KG
729;09072000;Cravo-da-india (frutos, flores e pedunculos), triturado ou em po;1;KG
730;09081100;Noz-moscada, nao triturada nem em po;1;KG
731;09081200;Noz-moscada, triturada ou em po;1;KG
732;09082100;Macis, nao triturado nem em po;1;KG
733;09082200;Macis, triturado ou em po;1;KG
734;09083100;Amomos e cardamomos, nao triturado nem em po;1;KG
735;09083200;Amomos e cardamomos, triturados ou em po;1;KG
736;09092100;Sementes de coentro, nao trituradas nem em po;1;KG
737;09092200;Sementes de coentro, trituradas ou em po;1;KG
738;09093100;Sementes de cominho, nao trituradas nem em po;1;KG
739;09093200;Sementes de cominho, trituradas ou em po;1;KG
740;09096110;Sementes de anis (erva-doce), nao trituradas nem em po;1;KG
741;09096120;Sementes de badiana (anis-estrelado), nao triturado nem em po;1;KG
742;09096190;Outras sementes, nao trituradas nem em po;1;KG
743;09096210;Sementes de anis (erva-doce), trituradas ou em po;1;KG
744;09096220;Sementes de badiana (anis-estrelado), trituradas ou em po;1;KG
745;09096290;Outras sementes, trituradas ou em po;1;KG
746;09101100;Gengibre, nao triturado nem em po;1;KG
747;09101200;Gengibre, triturado ou em po;1;KG
748;09102000;Acafrao;1;KG
749;09103000;Acafrao-da-terra (curcuma);1;KG
750;09109100;Misturas de especiarias;1;KG
751;09109900;Outras especiarias;1;KG
752;10011100;Trigo duro, para semeadura;1;KG
753;10011900;Trigo duro, exceto para semeadura;1;KG
754;10019100;Outrros trigos e misturas de trigo com centeio, para semeadura;1;KG
755;10019900;Outros trigos e misturas de trigo com centeio, exceto para semeadura;1;KG
756;10021000;Centeio, para semeadura;1;KG
757;10029000;Centeio, exceto para semeadura;1;KG
758;10031000;Cevada, para semeadura;1;KG
759;10039010;Cevada cervejeira;1;KG
760;10039080;Outras cevadas, em grao;1;KG
761;10039090;Outras cevadas, exceto em grao;1;KG
762;10041000;Aveia, para semeadura;1;KG
763;10049000;Aveia, exceto para semeadura;1;KG
764;10051000;Milho para semeadura;1;KG
765;10059010;Milho em grao, exceto para semeadura;1;KG
766;10059090;Milho, exceto em grao;1;KG
767;10061010;Arroz com casca (arroz paddy), para semeadura;1;KG
768;10061091;Arroz com casca (arroz paddy), parboilizado;1;KG
769;10061092;Arroz com casca (arroz paddy), nao parboilizado;1;KG
770;10062010;Arroz descascado (arroz cargo ou castanho), descascado, parboilizado;1;KG
771;10062020;Arroz descascado (arroz cargo ou castanho), nao parboilizado;1;KG
772;10063011;Arroz semibranqueado ou branqueado, parboilizado, polido ou brunido;1;KG
773;10063019;Outros tipode de arroz semibranqueado ou branqueado, parboilizado;1;KG
774;10063021;Arroz semibranqueado ou branqueado, nao parboilizado, polido ou brunido;1;KG
775;10063029;Outros tipode de arroz semibranqueado ou branqueado, nao parboilizado;1;KG
776;10064000;Arroz quebrado;1;KG
777;10071000;Sorgo de grao, para semeadura;1;KG
778;10079000;Sorgo de grao, exceto para semeadura;1;KG
779;10081010;Trigo mourisco para semeadura;1;KG
780;10081090;Trigo mourisco, exceto para semeadura;1;KG
781;10082110;Milheto (Pennisetum glaucum), para semeadura;1;KG
782;10082190;Outros paincos, para semeadura;1;KG
783;10082910;Milheto (Pennisetum glaucum), exceto para semeadura;1;KG
784;10082990;Outros paincos, exceto para semeadura;1;KG
785;10083010;Alpiste para semeadura;1;KG
786;10083090;Alpiste, exceto para semeadura;1;KG
787;10084010;Milha (Digitaria spp.), para semeadura;1;KG
788;10084090;Milha (Digitaria spp.), exceto para semeadura;1;KG
789;10085010;Quinoa (Chenopodium quinoa), para semeadura;1;KG
790;10085090;Quinoa (Chenopodium quinoa), exceto para semeadura;1;KG
791;10086010;Triticale, para semeadura;1;KG
792;10086090;Triticale, exceto para semeadura;1;KG
793;10089010;Outros cereais para semeadura;1;KG
794;10089090;Outros cereais, exceto para semeadura;1;KG
795;11010010;Farinha de trigo;1;KG
796;11010020;Farinha de mistura de trigo com centeio (meteil);1;KG
797;11022000;Farinha de milho;1;KG
798;11029000;Farinha de outros cereais;1;KG
799;11031100;Grumos e semolas, de trigo;1;KG
800;11031300;Grumos e semolas, de milho;1;KG
801;11031900;Grumos e semolas, de outros cereais;1;KG
802;11032000;Pellets de cereais;1;KG
803;11041200;Graos de aveia, esmagados ou em flocos;1;KG
804;11041900;Graos de outros cereais, esmagados ou em flocos;1;KG
805;11042200;Outros graos trabalhados (por exemplo, descascados, em perolas, cortados ou partidos), de aveia;1;KG
806;11042300;Outros graos trabalhados (por exemplo, descascados, em perolas, cortados ou partidos), de milho;1;KG
807;11042900;Outros graos trabalhados (por exemplo, descascados, em perolas, cortados ou partidos), de outros cereais;1;KG
808;11043000;Germes de cereais, inteiros, esmagados, em flocos ou moidos;1;KG
809;11051000;Farinha, semola e po, de batata;1;KG
810;11052000;Flocos, granulos e pellets, de batata;1;KG
811;11061000;Farinhas, semolas e pos, dos legumes de vagem, secos, da posicao 07.13;1;KG
812;11062000;Farinhas, semolas e pos, de sagu ou das raizes ou tuberculos, da posicao 07.14;1;KG
813;11063000;Farinhas, semolas e pos, dos produtos do Capitulo 8 (frutas, cascas de citricos, etc);1;KG
814;11071010;Malte nao torrado, inteiro ou partido;1;KG
815;11071020;Malte nao torrado, moido ou em farinha;1;KG
816;11072010;Malte torrado, inteiro ou partido;1;KG
817;11072020;Malte torrado, moido ou em farinha;1;KG
818;11081100;Amido de trigo;1;KG
819;11081200;Amido de milho;1;KG
820;11081300;Fecula de batata;1;KG
821;11081400;Fecula de mandioca;1;KG
822;11081900;Outros amidos e feculas;1;KG
823;11082000;Inulina;1;KG
824;11090000;Gluten de trigo, mesmo seco;1;KG
825;12011000;Soja, mesmo triturada, para semeadura;1;KG
826;12019000;Soja, mesmo triturada, exceto para semeadura;1;TON
827;12023000;Amendoins, nao torrados nem cozidos, para semeadura;1;KG
828;12024100;Amendoins com casca, nao torrados, nem cozidos;1;KG
829;12024200;Amendoins descascados, mesmo triturados;1;KG
830;12030000;Copra;1;KG
831;12040010;Sementes de linho (linhaca) para semeadura;1;KG
832;12040090;Outras sementes de linho (linhaca), mesmo trituradas;1;KG
833;12051010;Sementes de nabo silvestre, baixo teor, para semeadura;1;KG
834;12051090;Sementes de nabo silvestre baixo teor, exceto para semeadura;1;KG
835;12059010;Outras sementes de nabo silvestre, para semeadura;1;KG
836;12059090;Outras sementes de nabo silvestre, exceto para semeadura;1;KG
837;12060010;Sementes de girassol, para semeadura;1;KG
838;12060090;Outras sementes de girassol, mesmo trituradas;1;KG
839;12071010;Nozes e palmiste, para semeadura;1;KG
840;12071090;Outras nozes e palmiste, mesmo triturados;1;KG
841;12072100;Sementes de algodao, para semeadura;1;KG
842;12072900;Sementes de algodao, exceto para semeadura;1;KG
843;12073010;Sementes de ricino, para semeadura;1;KG
844;12073090;Outras sementes de ricino, mesmo trituradas;1;KG
845;12074010;Sementes de gergelim, para semeadura;1;KG
846;12074090;Outras sementes de gergelim, mesmo trituradas;1;KG
847;12075010;Sementes de mostarda, para semeadura;1;KG
848;12075090;Outras sementes de mostarda, mesmo trituradas;1;KG
849;12076010;Sementes de cartamo, para semeadura;1;KG
850;12076090;Outras sementes de cartamo, mesmo trituradas;1;KG
851;12077010;Sementes de melao, para semeadura;1;KG
852;12077090;Sementes de melao, exceto para semeadura;1;KG
853;12079110;Sementes de dormideira ou papoula, para semeadura;1;KG
854;12079190;Outras sementes de dormideira ou papoula, mesmo trituradas;1;KG
855;12079910;Outras sementes e frutos oleaginosos, para semeadura;1;KG
856;12079990;Outras sementes e frutos oleaginosos, mesmo triturados;1;KG
857;12081000;Farinha de soja;1;KG
858;12089000;Farinhas de outras sementes, frutos oleaginosos, exceto de mostarda;1;KG
859;12091000;Sementes de beterraba sacarina, para semeadura;1;KG
860;12092100;Sementes de alfafa (luzerna), para semeadura;1;KG
861;12092200;Sementes de trevo (Trifolium spp), para semeadura;1;KG
862;12092300;Sementes de festuca, para semeadura;1;KG
863;12092400;Sementes de pasto dos prados do Kentucky, para semeadura;1;KG
864;12092500;Sementes de azevem, para semeadura;1;KG
865;12092900;Outras sementes forrageiras, para semeadura;1;KG
866;12093000;Sementes de plantas herbaceas, cultivadas para flores, para semeadura;1;KG
867;12099100;Sementes de produtos horticolas, para semeadura;1;KG
868;12099900;Outras sementes, frutos e esporos, para semeadura;1;KG
869;12101000;Cones de lupulo, frescos, secos, nao triturados, nao moidos, etc;1;KG
870;12102010;Cones de lupulo, triturados ou moidos, ou em pellets;1;KG
871;12102020;Lupulina;1;KG
872;12112000;Raizes de ginseng, frescas, secas, inclusive cortadas, trituradas, em po;1;KG
873;12113000;Coca (folha de), para utilizacao em perfumaria, medicina, etc.;1;KG
874;12114000;Palha de dormideira ou papoula, para utilizacao em perfumaria, medicina, etc.;1;KG
875;12115000;Efedra;1;KG
876;12119010;Oregano (Origanum vulgare) fresco ou seco, para perfumaria, medicina, etc.;1;KG
877;12119090;Outras plantas e partes, para perfumaria, medicina e semelhantes;1;KG
878;12122100;Algas proprias para a alimentacao humana;1;KG
879;12122900;Outras algas, frescas, refrigeradas, congeladas ou secas;1;KG
880;12129100;Beterraba sacarina, fresca, refrigerada, congelada, seca, em po;1;KG
881;12129200;Cana-de-acucar fresca, refrigerada, congelada, seca, em po;1;KG
882;12129300;Cana-de-acucar, fresca, regrigerada, congelada ou seca;1;KG
883;12129400;Raizes de chicoria, fresca, refrigerada, congelada ou seca;1;KG
884;12129910;Stevia rebaudiana;1;KG
885;12129990;Outros produtos vegetais utilizados principalmente na alimentacao humana;1;KG
886;12130000;Palhas e cascas de cereais, em bruto, mesmo picadas, moidas, prensadas ou em pellets;1;KG
887;12141000;Farinha e pellets, de alfafa (luzerna);1;KG
888;12149000;Rutabagas, raizes forrageiras e outros produtos forrageiros;1;KG
889;13012000;Goma-arabica;1;KG
890;13019010;Goma-laca;1;KG
891;13019090;Outras gomas, resinas, goma-resinas, balsamos naturais;1;KG
892;13021110;Concentrado de palha de papoula;1;KG
893;13021190;Outros sucos e extratos vegetais, de opio;1;KG
894;13021200;Sucos e extratos, de alcacuz;1;KG
895;13021300;Sucos e extratos, de lupulo;1;KG
896;13021400;Sucos e extratos vegetais, de efedra;1;KG
897;13021910;Sucos e extratos, de mamao (Carica papaya), seco;1;KG
898;13021920;Sucos e extratos, de semente de toranja ou de pomelo;1;KG
899;13021930;Sucos e extratos de gin kgo biloba, seco;1;KG
900;13021940;Sucos e extratos, valepotriatos;1;KG
901;13021950;Sucos e extratos, de ginseng;1;KG
902;13021960;Sucos e extratos, de silimarina;1;KG
903;13021991;Sucos e extratos de piretro ou de raizes de plantas que contenha rotenona;1;KG
904;13021999;Outros sucos e extratos vegetais;1;KG
905;13022010;Materias pecticas (pectinas);1;KG
906;13022090;Outras materias pecticas, pectinatos e pectatos;1;KG
907;13023100;Agar-agar;1;KG
908;13023211;Farinha de endosperma;1;KG
909;13023219;Outros produtos mucilaginosos espessantes, de alfarroba e sementes;1;KG
910;13023220;Produtos mucilaginosos e espessantes, de sementes de guare;1;KG
911;13023910;Carragenina (musgo-da-irlanda);1;KG
912;13023990;Produtos mucilaginosos e espessantes, derivados de outros vegetais;1;KG
913;14011000;Bambus para cestaria ou espartaria;1;KG
914;14012000;Rotins para cestaria ou espartaria;1;KG
915;14019000;Outras materias vegetais para cestaria ou espartaria;1;KG
916;14042010;Linteres de algodao, em bruto;1;KG
917;14042090;Outros linteres de algodao;1;KG
918;14049010;Materias vegetais das especies principalmente utilizadas na fabricacao de vassouras, escovas, pinceis e artigos semelhantes (por exemplo, sorgo, piacaba, raiz de grama, tampico), mesmo torcidas ou em feixes;1;KG
919;14049090;Outros produtos de origem vegetal, para entrancar;1;KG
920;15011000;Banha de porco;1;KG
921;15012000;Outras gorduras de porco;1;KG
922;15019000;Gordura de aves;1;KG
923;15021011;Sebo bovino, em bruto;1;KG
924;15021012;Sebo bovino fundido (incluindo o premier jus);1;KG
925;15021019;Outros sebos bovinos;1;KG
926;15021090;Outras gorduras bovinas;1;KG
927;15029000;Gorduras ovinas ou caprinas;1;KG
928;15030000;Estearina solar, oleo de banha de porco, oleo-estearina, oleo-margarina e oleo de sebo, nao emulsionados nem misturados, nem preparados de outro modo;1;KG
929;15041011;Oleos de figados de bacalhau, em bruto;1;KG
930;15041019;Outros oleos de figados de bacalhau;1;KG
931;15041090;Oleos de figados de outros peixes e respectivas fracoes;1;KG
932;15042000;Gorduras e oleos de peixes e respectivas fracoes, exceto oleos de figados;1;KG
933;15043000;Gorduras e oleos de mamiferos marinhos e respectivas fracoes;1;KG
934;15050010;Lanolina;1;KG
935;15050090;Outras substancias gordas derivadas da lanolina, incluindo a suarda;1;KG
936;15060000;Outras gorduras e oleos animais, e respectivas fracoes, mesmo refinados, mas nao quimicamente modificados;1;KG
937;15071000;Oleo de soja, em bruto, mesmo degomado;1;TON
938;15079011;Oleo de soja, refinado, em recipientes com capacidade inferior ou igual a 5 litros;1;TON
939;15079019;Oleo de soja, refinado, em recipientes com capacidade menor que 5 litros;1;TON
940;15079090;Outros oleos de soja;1;TON
941;15081000;Oleo de amendoim, em bruto;1;KG
942;15089000;Outros oleos de amendoim;1;KG
943;15091000;Azeite de oliva, virgem;1;KG
944;15099010;Azeite de oliva, refinado;1;KG
945;15099090;Outros azeites de oliva;1;KG
946;15100000;Outros oleos e respectivas fracoes, obtidos exclusivamente a partir de azeitonas, mesmo refinados, mas nao quimicamente modificados, e misturas desses oleos ou fracoes com oleos ou fracoes da posicao 15.09;1;KG
947;15111000;Oleos de dende, em bruto;1;KG
948;15119000;Outros oleos de dende;1;KG
949;15121110;Oleo de girassol, em bruto;1;KG
950;15121120;Oleo de cartamo, em bruto;1;KG
951;15121911;Oleo de girassol, refinado, em recipientes com capacidade inferior ou igual a 5 litros;1;KG
952;15121919;Outros oleos de girassol;1;KG
953;15121920;Outros oleos de cartamo;1;KG
954;15122100;Oleo de algodao, em bruto, mesmo desprovido de gossipol;1;KG
955;15122910;Oleo de algodao, refinado;1;KG
956;15122990;Outros oleos de algodao;1;KG
957;15131100;Oleo de coco (oleo de copra), em bruto;1;KG
958;15131900;Outros oleos de coco (oleos de copra);1;KG
959;15132110;Oleo de amendoa de palma (palmiste), em bruto;1;KG
960;15132120;Oleo de babacu, em bruto;1;KG
961;15132910;Outros oleos de palmiste;1;KG
962;15132920;Outros oleos de babacu;1;KG
963;15141100;Oleos de nabo silvestre, baixo teor, em bruto;1;KG
964;15141910;Oleos de nabo silvestre, baixo teor, refinados;1;KG
965;15141990;Outros oleos de nabo silvestre, baixo teor;1;KG
966;15149100;Outros oleos de nabo silvestre, em bruto;1;KG
967;15149910;Outros oleos de nabo silvestre, refinados;1;KG
968;15149990;Outros oleos de nabo silvestre;1;KG
969;15151100;Oleo de linhaca, em bruto;1;KG
970;15151900;Outros oleos de linhaca;1;KG
971;15152100;Oleo de milho, em bruto;1;KG
972;15152910;Oleo de milho, refinado, em recipientes com capacidade inferior ou igual a 5 litros;1;KG
973;15152990;Outros oleos de milho;1;KG
974;15153000;Oleo de ricino e respectivas fracoes;1;KG
975;15155000;Oleo de gergelim e respectivas fracoes;1;KG
976;15159010;Oleo de jojoba e respectivas fracoes;1;KG
977;15159021;Oleo de tungue em bruto, nao modificado quimicamente;1;KG
978;15159022;Oleos de tungue, refinado, nao modificado quimicamente;1;KG
979;15159090;Outras gorduras e oleos vegetais, mesmo refinado;1;KG
980;15161000;Gorduras e oleos animais e respectivas fracoes;1;KG
981;15162000;Gorduras e oleos vegetais e respectivas fracoes;1;KG
982;15171000;Margarina, exceto a margarina liquida;1;KG
983;15179010;Misturas de oleos refinados, em recipientes com capacidade inferior ou igual a 5 litros;1;KG
984;15179090;Outras misturas, preparacoes alimenticias de gorduras, oleos, etc.;1;KG
985;15180010;Oleo vegetal epoxidado;1;KG
986;15180090;Outras gorduras e oleos animais/vegetais cozidos, oxidados, etc.;1;KG
987;15200010;Glicerol em bruto;1;KG
988;15200020;Agua e lixivia, glicericas;1;KG
989;15211000;Ceras vegetais;1;KG
990;15219011;Cera de abelha, em bruto;1;KG
991;15219019;Outras ceras de abelha;1;KG
992;15219090;Ceras de outros insetos e espermacete, mesmo refinados, corados;1;KG
993;15220000;Degras, residuos provenientes do tratamento das substancias gordas ou das ceras animais ou vegetais;1;KG
994;16010000;Enchidos e produtos semelhantes, de carne, de miudezas ou de sangue, preparacoes alimenticias a base de tais produtos;1;KG
995;16021000;Preparacoes alimenticias homogeneizadas, de carnes, miudezas, sangue;1;KG
996;16022000;Preparacoes alimenticias e conservas, de figados de quaisquer animais;1;KG
997;16023100;Preparacoes alimenticias e conservas, de peruas e de perus;1;KG
998;16023210;Preparacoes e conservas de galos e galinhas, com conteudo de carne ou de miudezas superior ou igual a 57 %, em peso, nao cozidas;1;KG
999;16023220;Preparacoes e conservas de galos e galinhas, com conteudo de carne ou de miudezas superior ou igual a 57 %, em peso, cozidas;1;KG
1000;16023230;Preparacoes e conservas de galos e galinhas, com conteudo de carne ou de miudezas superior ou igual a 25 % e inferior a 57 %, em peso;1;KG
1001;16023290;Outras preparacoes e conservas de galos e galinhas;1;KG
1002;16023900;Preparacoes alimenticias e conservas, de outras aves;1;KG
1003;16024100;Preparacoes alimenticias em conservas, de pernas, seus pedacos, de suinos;1;KG
1004;16024200;Preparacoes alimenticias/conservas, de pas, seus pedacos, de suinos;1;KG
1005;16024900;Outras preparacoes alimenticias e conservas, de suinos e misturas;1;KG
1006;16025000;Preparacoes alimenticias e conservas, da especie bovina;1;KG
1007;16029000;Outras preparacoes alimenticias e conservas, de carnes, miudezas, incluindo as preparacoes de sangue de quaisquer animais;1;KG
1008;16030000;Extratos e sucos de carne, de peixes ou de crustaceos, de moluscos ou de outros invertebrados aquaticos;1;KG
1009;16041100;Preparacoes e conservas, de salmoes, inteiros ou em pedacos, exceto peixes picados;1;KG
1010;16041200;Preparacoes e conservas, de arenques, inteiros ou em pedacos, exceto peixes picados:;1;KG
1011;16041310;Preparacoes e conservas, de sardinhas, inteiros ou em pedacos, exceto peixes picados;1;KG
1012;16041390;Preparacoes e conservas, de sardinelas, espadilhas, inteiras ou em pedacos;1;KG
1013;16041410;Preparacoes e conservas, de atuns, inteiros ou em pedacos, exceto peixes picados;1;KG
1014;16041420;Preparacoes e conservas, de bonitos-listrados, inteiros ou em pedacos, exceto peixes picados;1;KG
1015;16041430;Preparacoes e conservas, de bonitos-cachorros, inteiros ou em pedacos, exceto peixes picados;1;KG
1016;16041500;Preparacoes e conservas, de cavalas, cavalinhas, etc, inteiros ou em pedacos, exceto peixes picados:;1;KG
1017;16041600;Preparacoes e conservas, de anchovas, inteiros ou em pedacos, exceto peixes picados;1;KG
1018;16041700;Preparacoes e conservas, de enguias;1;KG
1019;16041800;Barbatanas de tubarao, preparados e conservados;1;KG
1020;16041900;Preparacoes e conservas de outros peixes, inteiros, em pedacos;1;KG
1021;16042010;Outras preparacoes e conservas, de atuns;1;KG
1022;16042020;Outras preparacoes e conservas, de bonitos-listrados;1;KG
1023;16042030;Outras preparacoes e conservas, de sardinhas, sardinelas, etc.;1;KG
1024;16042090;Outras preparacoes e conservas, de outros peixes;1;KG
1025;16043100;Caviar;1;KG
1026;16043200;Sucedaneos de caviar;1;KG
1027;16051000;Preparacoes e conservas, de caranguejos;1;KG
1028;16052100;Preparacoes e conservas de camaroes, nao acondicionados em recipientes hermeticamente fechados;1;KG
1029;16052900;Preparacoes e conservas de camaroes, exceto nao acondicionadas em recipientes hermeticamente fechados;1;KG
1030;16053000;Preparacoes e conservas, de lavagantes;1;KG
1031;16054000;Preparacoes e conservas, de outros crustaceos;1;KG
1032;16055100;Preparacoes e conservas, de ostras;1;KG
1033;16055200;Preparacoes e conservas, de vieiras e outros mariscos;1;KG
1034;16055300;Preparacoes e conservas, de mexilhoes;1;KG
1035;16055400;Preparacoes e conservas, sepias e lulas;1;KG
1036;16055500;Preparacoes e conservas, de polvos;1;KG
1037;16055600;Preparacoes e conservas, de ameijoas, berbigoes e arcas;1;KG
1038;16055700;Preparacoes e conservas, de abalones;1;KG
1039;16055800;Preparacoes e conservas, de caracois (exceto os do mar);1;KG
1040;16055900;Preparacoes e conservas, de outros moluscos;1;KG
1041;16056100;Preparacoes e conservas, de pepinos-do-mar;1;KG
1042;16056200;Preparacoes e conservas, de ouricos-do-mar;1;KG
1043;16056300;Preparacoes e conservas, de medusas (aguas-vivas);1;KG
1044;16056900;Preparacoes e conservas, de outros invertebrados aquaticos;1;KG
1045;17011200;Acucar de beterraba, em bruto;1;KG
1046;17011300;Acucar de cana mencionado na nota 2 da posicao 1701;1;TON
1047;17011400;Outros acucares de cana;1;TON
1048;17019100;Outros acucares de cana, beterraba, com aromatizante corante;1;KG
1049;17019900;Outros acucares de cana, beterraba, sacarose quimicamente pura, sol.;1;TON
1050;17021100;Lactose e xarope de lactose, que contenham, em peso, 99 % ou mais de lactose, expresso em lactose anidra, calculado sobre a materia seca;1;KG
1051;17021900;Outras lactoses e xaropes de lactose;1;KG
1052;17022000;Acucar e xarope, de bordo (acer);1;KG
1053;17023011;Glicose quimicamente pura;1;KG
1054;17023019;Outras glicoses que contenham, em peso, no estado seco, menos de 20 % de frutose (levulose);1;KG
1055;17023020;Xarope de glicose contendo estado seco, peso < 20% de frutose;1;KG
1056;17024010;Glicose que contenha, em peso, no estado seco, um teor de frutose (levulose) igual ou superior a 20 % e inferior a 50 %, com excecao do acucar invertido;1;KG
1057;17024020;Xarope de glicose, que contenham, em peso, no estado seco, um teor de frutose (levulose) igual ou superior a 20 % e inferior a 50 %, com excecao do acucar invertido;1;KG
1058;17025000;Frutose (levulose) quimicamente pura;1;KG
1059;17026010;Frutose que contenha, em peso, no estado seco, um teor de frutose (levulose) superior a 50 %, com excecao do acucar invertido;1;KG
1060;17026020;Xarope de frutose, que contenha, em peso, no estado seco, um teor de frutose (levulose) superior a 50 %, com excecao do acucar invertido;1;KG
1061;17029000;Outros acucares, xaropes de acucares, sucedaneos do mel, etc, que contenham, em peso, no estado seco, 50 % de frutose (levulose);1;KG
1062;17031000;Melacos de cana;1;KG
1063;17039000;Outros melacos da extracao ou refinacao do acucar;1;KG
1064;17041000;Gomas de mascar, mesmo revestidas de acucar, sem cacau;1;KG
1065;17049010;Chocolate branco, sem cacau;1;KG
1066;17049020;Caramelos, confeitos, dropes, pastilhas, e produtos semelhantes, sem cacau;1;KG
1067;17049090;Outros produtos de confeitaria, sem cacau;1;KG
1068;18010000;Cacau inteiro ou partido, em bruto ou torrado;1;TON
1069;18020000;Cascas, peliculas e outros desperdicios de cacau;1;KG
1070;18031000;Pasta de cacau, nao desengordurada;1;TON
1071;18032000;Pasta de cacau, total ou parcialmente desengordurada;1;TON
1072;18040000;Manteiga, gordura e oleo, de cacau;1;TON
1073;18050000;Cacau em po, sem adicao de acucar ou outros edulcorantes;1;TON
1074;18061000;Cacau em po, com adicao de acucar ou outros edulcorantes;1;KG
1075;18062000;Outras preparacoes com cacau, em blocos ou em barras, com peso superior a 2 kg, ou no estado liquido, em pasta, em po, granulos ou formas semelhantes, em recipientes ou embalagens imediatas de conteudo superior a 2 kg;1;KG
1076;18063110;Chocolate recheado, em tabletes, barras e paus;1;KG
1077;18063120;Outras preparacoes alimenticias com cacau, recheadas, em tabletes, barras e paus;1;KG
1078;18063210;Chocolate nao recheado, em tabletes, barras e paus;1;KG
1079;18063220;Outras preparacoes alimenticias com cacau, nao recheadas, em tabletes, etc.;1;KG
1080;18069000;Outros chocolates e preparacoes alimenticias contendo cacau;1;KG
1081;19011010;Leite modificado, para alimentacao de criancas, acondicionadas para venda a retalho;1;KG
1082;19011020;Farinha lactea, para alimentacao de criancas, acondicionadas para venda a retalho;1;KG
1083;19011030;Preparacoes a base de farinha, grumos, semola ou amido, para alimentacao de criancas, acondicionadas para venda a retalho;1;KG
1084;19011090;Outras preparacoes para alimentacao de criancas, acondicionadas para venda a retalho;1;KG
1085;19012000;Misturas e pastas para a preparacao de produtos de padaria, pastelaria e da industria de bolachas e biscoitos, da posicao 19.05;1;KG
1086;19019010;Extrato de malte;1;KG
1087;19019020;Doce de leite;1;KG
1088;19019090;Outras preparacoes alimenticias de farinhas, etc, cacau < 40%;1;KG
1089;19021100;Massas alimenticias nao cozidas, nem recheadas, nem preparadas de outro modo, que contenham ovos;1;KG
1090;19021900;Outras massas alimenticias nao cozidas, nem recheadas, nem preparadas de outro modo;1;KG
1091;19022000;Massas alimenticias recheadas (mesmo cozidas ou preparadas de outro modo);1;KG
1092;19023000;Outras massas alimenticias;1;KG
1093;19024000;Cuscuz;1;KG
1094;19030000;Tapioca e seus sucedaneos preparados a partir de feculas, em flocos, grumos, graos, perolas ou formas semelhantes;1;KG
1095;19041000;Produtos a base de cereais, obtidos por expansao ou por torrefacao;1;KG
1096;19042000;Preparacoes alimenticias obtidas a partir de flocos de cereais nao torrados ou de misturas de flocos de cereais nao torrados com flocos de cereais torrados ou expandidos;1;KG
1097;19043000;Trigo bulgur;1;KG
1098;19049000;Outros cereais em graos, pre-cozidos, preparados de outro modo;1;KG
1099;19051000;Pao denominado kn�ckebrot;1;KG
1100;19052010;Panetone;1;KG
1101;19052090;Outros paes de especiarias;1;KG
1102;19053100;Bolachas e biscoitos, adicionados de edulcorante;1;KG
1103;19053200;Waffles e wafers;1;KG
1104;19054000;Torradas, pao torrado e produtos semelhantes torrados;1;KG
1105;19059010;Pao de forma;1;KG
1106;19059020;Bolachas;1;KG
1107;19059090;Outros produtos de padaria, pastelaria, industria de biscoitos, etc;1;KG
1108;20011000;Pepinos e pepininhos (cornichons), preparados ou conservados em vinagre ou em acido acetico;1;KG
1109;20019000;Outros produtos horticolas, frutas e outras partes comestiveis de plantas, preparados ou conservados em vinagre ou em acido acetico;1;KG
1110;20021000;Tomates inteiros ou pedacos, preparados ou conservados, exceto em vinagre ou em acido acetico;1;KG
1111;20029010;Sucos de tomates;1;KG
1112;20029090;Outros tomates preparados ou conservados, exceto em vinagre ou em acido acetico;1;KG
1113;20031000;Cogumelos do genero Agaricus, preparados ou conservados, exceto em vinagre ou em acido acetico;1;KG
1114;20039000;Outros cogumelos, preparados ou conservados, exceto em vinagre ou em acido acetico;1;KG
1115;20041000;Batatas, preparadas ou conservadas, exceto em vinagre ou em acido acetico, congeladas;1;KG
1116;20049000;Outros produtos horticolas e misturas de produtos horticolas, preparados ou conservados, exceto em vinagre ou em acido acetico, congelados, com excecao dos produtos da posicao 20.06;1;KG
1117;20051000;Produtos horticolas homogeneizados, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1118;20052000;Batatas, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1119;20054000;Ervilhas, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1120;20055100;Feijoes em graos, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1121;20055900;Outros feijoes, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1122;20056000;Aspargos, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1123;20057000;Azeitonas, preparadas ou conservadas, exceto em vinagre ou em acido acetico, nao congeladas;1;KG
1124;20058000;Milho doce (Zea mays var. saccharata), preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1125;20059100;Brotos de bambu, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1126;20059900;Outros produtos horticolas, preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados;1;KG
1127;20060000;Produtos horticolas, frutas, cascas de frutas e outras partes de plantas, conservados com acucar (passados por calda, glaceados ou cristalizados);1;KG
1128;20071000;Preparacoes homogeneizadas de frutas, obtidos por cozimento, com ou sem adicao de acucar ou de outros edulcorantes;1;KG
1129;20079100;Doces, geleias, marmelades, pures e pastas, de citricos;1;KG
1130;20079910;Geleias e marmelades, de outras frutas;1;KG
1131;20079921;Pures de acai (Euterpe oleracea);1;KG
1132;20079922;Pures de acerola (Malpighia spp.);1;KG
1133;20079923;Pures de banana (Musa spp.);1;KG
1134;20079924;Pures de goiaba (Psidium guajava);1;KG
1135;20079925;Pures de manga (Mangifera indica);1;KG
1136;20079929;Pures de outras frutas;1;KG
1137;20079990;Doces, pures e pastas, de outras frutas;1;KG
1138;20081100;Amendoins preparados ou conservados;1;KG
1139;20081900;Outras frutas de casca rija, outras sementes, preparadas/conservadas;1;KG
1140;20082010;Abacaxis (ananases), preparados ou conservados em agua edulcorada, incluindo os xaropes;1;KG
1141;20082090;Abacaxis (ananases), preparados ou conservados de outro modo;1;KG
1142;20083000;Citricos preparados ou conservados;1;KG
1143;20084010;Peras, preparadas ou conservadas em agua edulcorada, incluindo os xaropes;1;KG
1144;20084090;Peras preparadas ou conservadas de outro modo;1;KG
1145;20085000;Damascos preparados ou conservados;1;KG
1146;20086010;Cerejas preparadas/conservadas em agua edulcorada, inclusive xarope;1;KG
1147;20086090;Cerejas preparadas ou conservadas de outro modo;1;KG
1148;20087010;Pessegos, incluindo as nectarinas, preparados ou conservados em agua edulcorada, incluindo os xaropes;1;KG
1149;20087020;Pessegos, incluindo as nectarinas, preparados ou conservados em agua, polpa com valor Brix igual ou superior a 20;1;KG
1150;20087090;Pessegos, incluindo as nectarinas, preparados ou conservados de outro modo;1;KG
1151;20088000;Morangos preparados ou conservados;1;KG
1152;20089100;Palmitos preparados ou conservados;1;KG
1153;20089300;Airelas vermelhas, preparadas ou conservadas de outro modo;1;KG
1154;20089710;Misturas de frutas preparadas em agua edulcorada, inclusive corantes;1;KG
1155;20089790;Misturas de frutas preparadas,conservadas de outro modo;1;KG
1156;20089900;Outras frutas, partes de plantas, preparadas/conservadas de outro modo;1;KG
1157;20091100;Suco (sumo) de laranja, nao fermentados, sem adicao de alcool, com ou sem adicao de acucar ou de outros edulcorantes, congelado;1;KG
1158;20091200;Suco (sumo) de laranja, nao fermentados, sem adicao de alcool, com ou sem adicao de acucar ou de outros edulcorantes, nao congelado, com valor Brix nao superior a 20;1;KG
1159;20091900;Outros sucos de laranjas, nao fermentados, sem adicao de alcool, com ou sem adicao de acucar ou de outros edulcorantes;1;KG
1160;20092100;Suco (sumo) de toranja e de pomelo, com valor Brix nao superior a 20;1;KG
1161;20092900;Outros sucos de pomelo;1;KG
1162;20093100;Suco (sumo) de qualquer outro fruto citrico, com valor Brix nao superior a 20;1;KG
1163;20093900;Outros sucos de outros citricos;1;KG
1164;20094100;Suco (sumo) de abacaxi (ananas), com valor Brix nao superior a 20;1;KG
1165;20094900;Outros sucos de abacaxi;1;KG
1166;20095000;Sucos de tomates, nao fermentados;1;KG
1167;20096100;Suco (sumo) de uva (incluindo os mostos de uvas), com valor Brix nao superior a 30;1;KG
1168;20096900;Outros sucos de uvas;1;KG
1169;20097100;Suco (sumo) de maca, com valor Brix nao superior a 20;1;KG
1170;20097900;Outros sucos de maca;1;KG
1171;20098100;Suco (sumo) de airela vermelha;1;KG
1172;20098911;Suco de pessego com valor Brix igual ou superior a 60, com adicao de acucar e outros edulcorantes ou nao;1;KG
1173;20098912;Suco de acerola (Malpighia spp.), com adicao de acucar e outros edulcorantes ou nao;1;KG
1174;20098913;Suco de maracuja (Passiflora edulis) com adicao de acucar e outros edulcorantes ou nao;1;KG
1175;20098919;Suco de outras frutas ou produtos horticolas, com adicao de acucar e outros edulcorantes ou nao;1;KG
1176;20098990;Sucos (sumo) de outras frutas, nao fermentado, sem adicao de acucar;1;KG
1177;20099000;Misturas de sucos (sumos), nao fermentados, sem adicao de alcool, com ou sem adicao de acucar ou de outros edulcorantes;1;KG
1178;21011110;Cafe soluvel, mesmo descafeinado;1;TON
1179;21011190;Outros extratos, essencias e concentrados, de cafe;1;TON
1180;21011200;Preparacoes a base de extratos, essencias ou concentrados ou a base de cafe;1;TON
1181;21012010;Extratos, essencias e concentrados e preparacoes a base destes extratos, essencias ou concentrados, a base de cha;1;KG
1182;21012020;Extratos, essencias e concentrados e preparacoes a base destes extratos, essencias ou concentrados, a base de mate;1;KG
1183;21013000;Chicoria torrada e outros sucedaneos torrados do cafe e respectivos extratos, essencias e concentrados;1;KG
1184;21021010;Leveduras vivas Saccharomyces boulardii;1;KG
1185;21021090;Outras leveduras vivas;1;KG
1186;21022000;Leveduras mortas, outros microrganismos monocelulares mortos;1;KG
1187;21023000;Pos para levedar, preparados;1;KG
1188;21031010;Molho de soja, preparado, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1189;21031090;Outros molhos de soja, preparados;1;KG
1190;21032010;Ketchup e outros molhos de tomate, preparado, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1191;21032090;Outros ketchup e molhos de tomate, preparados;1;KG
1192;21033010;Farinha de mostarda;1;KG
1193;21033021;Mostarda preparada, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1194;21033029;Outras mostardas preparadas;1;KG
1195;21039011;Maionese, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1196;21039019;Outras maioneses;1;KG
1197;21039021;Condimentos e temperos, compostos, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1198;21039029;Outros condimentos e temperos, compostos;1;KG
1199;21039091;Outras preparacoes para molhos, molhos preparados, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1200;21039099;Outras preparacoes para molhos e molhos preparados;1;KG
1201;21041011;Preparacoes para caldos e sopas, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1202;21041019;Outras preparacoes para caldos e sopas;1;KG
1203;21041021;Caldos e sopas, preparados, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1204;21041029;Outros caldos e sopas, preparados;1;KG
1205;21042000;Preparacoes alimenticias compostas homogeneizadas;1;KG
1206;21050010;Sorvetes, mesmo que contenham cacau, em embalagens imediatas de conteudo inferior ou igual a 2 kg;1;KG
1207;21050090;Outros sorvetes, mesmo que contenham cacau;1;KG
1208;21061000;Concentrados de proteinas e substancias proteicas texturizadas;1;KG
1209;21069010;Outras preparacoes para elaboracao de bebidas;1;KG
1210;21069021;Pos para a fabricacao de pudins, em embalagens imediatas de conteudo inferior ou igual a 1 kg;1;KG
1211;21069029;Pos para preparacoes de cremes, sorvetes, flans, gelatinas ou preparacoes similares;1;KG
1212;21069030;Complementos alimentares;1;KG
1213;21069040;Misturas a base de ascorbato de sodio e glucose proprias para embutidos;1;KG
1214;21069050;Gomas de mascar, sem acucar;1;KG
1215;21069060;Caramelos, confeitos, pastilhas e produtos semelhantes, sem acucar;1;KG
1216;21069090;Outras preparacoes alimenticias;1;KG
1217;22011000;Aguas minerais e aguas gaseificadas, nao adicionadas de acucar ou de outros edulcorantes nem aromatizadas;1;LT
1218;22019000;Outras aguas, nao adicionadas de acucar ou de outros edulcorantes nem aromatizadas, gelo e neve;1;LT
1219;22021000;Aguas, incluindo as aguas minerais e as aguas gaseificadas, adicionadas de acucar ou de outros edulcorantes ou aromatizadas;1;LT
1220;22029100;Cerveja sem alcool;1;LT
1221;22029900;Outras bebidas nao-alcoolicas (exceto agua, cerveja sem alcool e itens da posicao 20.09);1;LT
1222;22030000;Cervejas de malte;1;LT
1223;22041010;Vinhos espumantes e vinhos espumosos, tipo champanha (champagne);1;LT
1224;22041090;Outros vinhos de uvas frescas, espumantes e espumosos;1;LT
1225;22042100;Outros vinhos, mostos de uvas, fermentados, impedidos alcool, em recipientes de capacidade nao superior a 2 litros;1;LT
1226;22042211;Vinhos em recipientes de capacidade nao superior a 5�litros;1;LT
1227;22042219;Vinhos em recipientes de capacidade superior a 5�litros;1;LT
1228;22042220;Mostos de uvas, em recipientes de capacidade superior a 2 litros, mas nao superior a 10 litros;1;LT
1229;22042910;Vinhos em recipientes de capacidade superior a 10 litros;1;LT
1230;22042920;Mostos;1;LT
1231;22043000;Outros mostos de uvas;1;LT
1232;22051000;Vermutes, outros vinhos de uvas frescas, aromatizados, em recipientes de capacidade nao superior a 2 litros;1;LT
1233;22059000;Outros vermutes e vinhos de uvas frescas, aromatizados;1;LT
1234;22060010;Sidra;1;LT
1235;22060090;Outras bebidas fermentadas e misturas de bebidas fermentadas e misturas de bebidas fermentadas com bebidas nao alcoolicas, nao especificadas nem compreendidas noutras posicoes;1;LT
1236;22071010;Alcool etilico nao desnaturado, com um teor alcoolico, em volume, igual ou superior a 80 % vol, com um teor de agua igual ou inferior a 1 % vol;1;LT
1237;22071090;Outro alcool etilico nao desnaturado;1;LT
1238;22072011;Alcool etilico com um teor de agua igual ou inferior a 1 % vol;1;LT
1239;22072019;Outro alcool etilico desnaturado;1;LT
1240;22072020;Aguardente desnaturado com qualquer teor alcoolico;1;LT
1241;22082000;Aguardentes de vinho ou de bagaco de uvas;1;LT
1242;22083010;Uisques, com um teor alcoolico, em volume, superior a 50 % vol, em recipientes de capacidade superior ou igual a 50 litros;1;LT
1243;22083020;Uisques, em embalagens de capacidade inferior ou igual a 2 litros;1;LT
1244;22083090;Outros uisques;1;LT
1245;22084000;Rum e outras aguardentes provenientes da destilacao, apos fermentacao, de produtos da cana-de-acucar;1;LT
1246;22085000;Gim (gin) e genebra;1;LT
1247;22086000;Vodca;1;LT
1248;22087000;Licores;1;LT
1249;22089000;Outras bebidas alcoolicas;1;LT
1250;22090000;Vinagres e seus sucedaneos obtidos a partir do acido acetico, para usos alimentares;1;LT
1251;23011010;Farinhas, pos e pellets, de carnes, torresmos, improprios para alimentacao humana;1;KG
1252;23011090;Farinhas, pos e pellets, de miudezas, torresmos, improprios para alimentacao humana;1;KG
1253;23012010;Farinhas, pos e pellets, de peixes, improprios para alimentacao humana;1;KG
1254;23012090;Farinhas, pos e pellets, de crustaceos, de moluscos ou de outros invertebrados aquaticos, improprios para alimentacao humana;1;KG
1255;23021000;Semeas, farelos e outros residuos, mesmo em pellets, da peneiracao, moagem ou de outros tratamentos de milho;1;KG
1256;23023010;Farelo de trigo;1;KG
1257;23023090;Semeas e outros residuos, de trigo;1;KG
1258;23024000;Semeas, farelos e outros residuos, de outros cereais;1;KG
1259;23025000;Semeas, farelos e outros residuos, de leguminosas;1;KG
1260;23031000;Residuos da fabricacao do amido e residuos semelhantes;1;KG
1261;23032000;Polpas de beterraba, bagacos de cana-de-acucar e outros desperdicios da industria do acucar;1;KG
1262;23033000;Borras e desperdicios da industria da cerveja e das destilarias;1;KG
1263;23040010;Farinhas e pellets, da extracao do oleo de soja;1;TON
1264;23040090;Bagacos e outros residuos solidos, da extracao do oleo de soja;1;TON
1265;23050000;Tortas e outros residuos solidos, mesmo triturados ou em pellets, da extracao do oleo de amendoim;1;KG
1266;23061000;Tortas e outros residuos solidos, de sementes de algodao;1;KG
1267;23062000;Tortas e outros residuos solidos, de linhaca (sementes de linho);1;KG
1268;23063010;Tortas, farinhas e pellets, de sementes de girassol;1;KG
1269;23063090;Outros residuos solidos, do girassol;1;KG
1270;23064100;Torta de sementes de nabo silvestre ou de colza, com baixo teor de acido erucico;1;KG
1271;23064900;Outras tortas de nabo silvestre ou colza;1;KG
1272;23065000;Tortas e outros residuos solidos, de coco ou de copra;1;KG
1273;23066000;Tortas e outros residuos solidos, de nozes ou de palmiste;1;KG
1274;23069010;Tortas, residuos, etc, de germe de milho;1;KG
1275;23069090;Tortas, residuos, etc, da extracao de outros oleos vegetais;1;KG
1276;23070000;Borras de vinho, tartaro em bruto;1;KG
1277;23080000;Materias vegetais e desperdicios vegetais, residuos e subprodutos vegetais, mesmo em pellets, dos tipos utilizados na alimentacao de animais, nao especificados nem compreendidos noutras posicoes;1;KG
1278;23091000;Alimentos para caes ou gatos, acondicionados para venda a retalho;1;KG
1279;23099010;Preparacoes destinadas a fornecer ao animal a totalidade dos elementos nutritivos necessarios para uma alimentacao diaria racional e equilibrada (alimentos compostos completos);1;KG
1280;23099020;Preparacoes a base de sal iodado, farinha de ossos, farinha de concha, cobre e cobalto;1;KG
1281;23099030;Bolachas e biscoitos, dos tipos utilizados na alimentacao de animais;1;KG
1282;23099040;Preparacoes que contenham Diclazuril, dos tipos utilizados na alimentacao de animais;1;KG
1283;23099050;Preparacoes com teor de cloridrato de ractopamina igual ou superior a 2 %, em peso, com suporte de farelo de soja, dos tipos utilizados na alimentacao de animais;1;KG
1284;23099060;Preparacoes que contenham xilanase e betagluconase, com suporte de farinha de trigo, dos tipos utilizados na alimentacao de animais;1;KG
1285;23099090;Outras preparacoes dos tipos utilizados na alimentacao de animais;1;KG
1286;24011010;Tabaco nao manufaturado, nao destalado, em folhas, sem secar nem fermentar;1;KG
1287;24011020;Tabaco nao manufaturado, nao destalado, em folhas secas ou fermentadas tipo capeiro;1;KG
1288;24011030;Tabaco nao manufaturado, nao destalado, em folhas secas em secador de ar quente (flue cured), do tipo Virginia;1;KG
1289;24011040;Tabaco nao manufaturado, nao destalado, em folhas secas, com um conteudo de oleos volateis superior a 0,2 %, em peso, do tipo turco;1;KG
1290;24011090;Outros tabacos nao manufaturados, nao destalados;1;KG
1291;24012010;Tabaco nao manufaturado, total ou parcialmente destalado, em folhas, sem secar nem fermentar;1;KG
1292;24012020;Tabaco nao manufaturado, total ou parcialmente destalado, em folhas secas ou fermentadas tipo capeiro;1;KG
1293;24012030;Tabaco nao manufaturado, total ou parcialmente destalado, em folhas secas em secador de ar quente (flue cured), do tipo Virginia;1;KG
1294;24012040;Tabaco nao manufaturado, total ou parcialmente destalado, em folhas secas (light air cured), do tipo Burley;1;KG
1295;24012090;Outros tabaco nao manufaturados, total ou parcialmente destalado;1;KG
1296;24013000;Desperdicios de tabaco;1;KG
1297;24021000;Charutos e cigarrilhas, que contenham tabaco;1;1000UN
1298;24022000;Cigarros que contenham tabaco;1;1000UN
1299;24029000;Charutos, cigarrilhas e cigarros, de sucedaneos do tabaco;1;1000UN
1300;24031100;Tabaco para narguile (cachimbo de agua) mencionado na Nota 1 de subposicao do presente Capitulo;1;KG
1301;24031900;Outros tabacos manufaturados para fumar, mesmo que contenha sucedaneos de tabaco em qualquer proporcao;1;KG
1302;24039100;Tabaco manufaturado homogeneizado ou reconstituido;1;KG
1303;24039910;Extratos e molhos, de tabaco, manufaturados;1;KG
1304;24039990;Outros produtos de tabaco e seus sucedaneos, manufaturados;1;KG
1305;25010011;Sal marinho, a granel, sem agregados;1;KG
1306;25010019;Outros tipos de sal a granel, sem agregados;1;KG
1307;25010020;Sal de mesa;1;KG
1308;25010090;Outros tipos de sal, cloreto de sodio puro e agua do mar;1;KG
1309;25020000;Piritas de ferro nao ustuladas;1;KG
1310;25030010;Enxofre de qualquer especie, exceto o enxofre sublimado, o precipitado e o coloidal, a  granel;1;KG
1311;25030090;Outras formas de enxofre de qualquer especie, exceto o enxofre sublimado, o precipitado e o coloidal;1;KG
1312;25041000;Grafita natural em po ou em escamas;1;KG
1313;25049000;Grafinat natural, em outras formas;1;KG
1314;25051000;Areias siliciosas e areias quartzosas;1;KG
1315;25059000;Outras areias naturais de qualquer especie, mesmo coradas, exceto areias metaliferas do Capitulo 26;1;KG
1316;25061000;Quartzo;1;KG
1317;25062000;Quartzitos, mesmo desbastados ou simplesmente cortados a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular;1;KG
1318;25070010;Caulim (caulino), mesmo calcinados;1;KG
1319;25070090;Outras argilas caulinicas, mesmo calcinadas;1;KG
1320;25081000;Bentonita;1;KG
1321;25083000;Argilas refratarias;1;KG
1322;25084010;Argilas plasticas, com teor de Fe2O3, em peso, inferior a 1,5 % e com perda por calcinacao, em peso, superior a 12 %;1;KG
1323;25084090;Outras argilas;1;KG
1324;25085000;Andaluzita, cianita e silimanita;1;KG
1325;25086000;Mulita;1;KG
1326;25087000;Barro cozido em po (terra de chamotte) e terra de dinas;1;KG
1327;25090000;Cre;1;KG
1328;25101010;Fosfatos de calcio naturais, nao moidos;1;KG
1329;25101090;Fosfatos aluminocalcicos, naturais, cre fosfatado, nao moidos;1;KG
1330;25102010;Fosfatos de calcio naturais, moidos;1;KG
1331;25102090;Fosfatos aluminocalcicos, naturais, cre fosfatado, moidos;1;KG
1332;25111000;Sulfato de bario natural (baritina);1;KG
1333;25112000;Carbonato de bario natural (witherita);1;KG
1334;25120000;Farinhas siliciosas fosseis (por exemplo, kieselguhr, tripolita, diatomita) e outras terras siliciosas analogas de densidade aparente nao superior a 1, mesmo calcinadas;1;KG
1335;25131000;Pedra-pomes, esmerilhado/outros abrasivos naturais tratamento termico;1;KG
1336;25132000;Esmeril, corindo natural, granada natural e outros abrasivos naturais;1;KG
1337;25140000;Ardosia, mesmo desbastada ou simplesmente cortada a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular;1;KG
1338;25151100;Marmores e travertinos, em bruto ou desbastados;1;M3
1339;25151210;Marmores, simplesmente cortados a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular;1;M3
1340;25151220;Travertinos, simplesmente cortados a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular;1;M3
1341;25152000;Granitos belgas e outras pedras calcarias de cantaria ou de construcao, alabastro;1;M3
1342;25161100;Granito em bruto ou desbastado;1;M3
1343;25161200;Granito, simplesmente cortado a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular;1;M3
1344;25162000;Arenito, cortado em blocos, placas, quadrado, retangular;1;M3
1345;25169000;Outras pedras de cantaria ou de construcao;1;KG
1346;25171000;Calhaus, cascalho, pedras britadas, dos tipos geralmente usados em concreto ou para empedramento de estradas, de vias ferreas ou outros balastros, seixos rolados e silex, mesmo tratados termicamente;1;KG
1347;25172000;Macadame de escorias de altos-fornos, de outras escorias ou de residuos industriais semelhantes, mesmo que contenham materias incluidas na subposicao 2517.10;1;KG
1348;25173000;Tarmacadame;1;KG
1349;25174100;Granulos, lascas e pos, das pedras das posicoes 25.15 ou 25.16, mesmo tratados termicamente, de marmore;1;KG
1350;25174900;Granulos, lascas e pos, das pedras das posicoes 25.15 ou 25.16, mesmo tratados termicamente, de outras pedras de cantaria;1;KG
1351;25181000;Dolomita nao calcinada nem sinterizada, denominada crua;1;KG
1352;25182000;Dolomita calcinada ou sinterizada;1;KG
1353;25183000;Aglomerados de dolomita;1;KG
1354;25191000;Carbonato de magnesio natural (magnesita);1;KG
1355;25199010;Magnesia eletrofundida;1;KG
1356;25199090;Magnesia calcinada a fundo e outros oxidos de magnesio;1;KG
1357;25201011;Gipsita em pedacos irregulares (pedras);1;KG
1358;25201019;Outras formas de gipsitas;1;KG
1359;25201020;Anidrita;1;KG
1360;25202010;Gesso moido, apto para uso odontologico;1;KG
1361;25202090;Outras formas de gesso;1;KG
1362;25210000;Castinas, pedras calcarias utilizadas na fabricacao de cal ou de cimento;1;KG
1363;25221000;Cal viva;1;KG
1364;25222000;Cal apagada;1;KG
1365;25223000;Cal hidraulica;1;KG
1366;25231000;Cimentos nao pulverizados, denominados clinkers;1;KG
1367;25232100;Cimentos Portland brancos, mesmo corados artificialmente;1;KG
1368;25232910;Cimentos portland, comuns;1;KG
1369;25232990;Outros tipos de cimento portland;1;KG
1370;25233000;Cimentos aluminosos;1;KG
1371;25239000;Outros cimentos hidraulicos;1;KG
1372;25241000;Crocidolita (amianto);1;KG
1373;25249000;Outras formas de amianto;1;KG
1374;25251000;Mica em bruto ou clivada em folhas ou lamelas irregulares (splittings);1;KG
1375;25252000;Mica em po;1;KG
1376;25253000;Desperdicios de mica;1;KG
1377;25261000;Esteatita natural, mesmo desbastada ou simplesmente cortada a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular, nao triturada nem em po;1;KG
1378;25262000;Esteatita natural, mesmo desbastada ou simplesmente cortada a serra ou por outro meio, em blocos ou placas de forma quadrada ou retangular, triturada ou em po e talco;1;KG
1379;25280000;Boratos naturais e seus concentrados (calcinados ou nao), exceto boratos extraidos de salmouras naturais, acido borico natural com um teor maximo de 85 % de H3BO3, em produto seco;1;KG
1380;25291000;Feldspato;1;KG
1381;25292100;Espatofluor, que contenha, em peso, 97 % ou menos de fluoreto de calcio;1;KG
1382;25292200;Espatofluor, que contenha, em peso, mais de 97 % de fluoreto de calcio;1;KG
1383;25293000;Leucita, nefelina e nefelina-sienito;1;KG
1384;25301010;Perlita nao expandida;1;KG
1385;25301090;Vermiculita e cloritas, nao expandidas;1;KG
1386;25302000;Quieserita, epsomita (sulfatos de magnesio naturais);1;KG
1387;25309010;Espodumenio;1;KG
1388;25309020;Areia de zirconio micronizada, propria para a preparacao de esmaltes ceramicos;1;KG
1389;25309030;Minerais de metais das terras raras;1;KG
1390;25309040;Terras corantes;1;KG
1391;25309090;Outras materias minerais;1;KG
1392;26011100;Minerios de ferro e seus concentrados, exceto as piritas de ferro ustuladas (cinzas de piritas), nao aglomerados;1;KG
1393;26011210;Minerios de ferro e seus concentrados, exceto as piritas de ferro ustuladas (cinzas de piritas), aglomerados por processo de peletizacao, de diametro superior ou igual a 8mm e inferior ou igual a 18mm;1;KG
1394;26011290;Outros minerios de ferro aglomerados;1;KG
1395;26012000;Piritas de ferro ustuladas (cinzas de piritas);1;KG
1396;26020010;Minerios de manganes e seus concentrados, incluindo os minerios de manganes ferruginosos e seus concentrados, de teor em manganes de 20 % ou mais, em peso, sobre o produto seco, aglomerados;1;KG
1397;26020090;Outros minerios de manganes e seus concentrados, incluindo os minerios de manganes ferruginosos e seus concentrados, de teor em manganes de 20 % ou mais, em peso, sobre o produto seco;1;KG
1398;26030010;Sulfetos de minerios de cobre e seus concentrados;1;KG
1399;26030090;Outros minerios de cobre e seus concentrados;1;KG
1400;26040000;Minerios de niquel e seus concentrados;1;KG
1401;26050000;Minerios de cobalto e seus concentrados;1;KG
1402;26060011;Bauxita nao calcinada (minerio de aluminio);1;KG
1403;26060012;Bauxita calcinada (minerio de aluminio);1;KG
1404;26060090;Outros minerios de aluminio e seus concentrados;1;KG
1405;26070000;Minerios de chumbo e seus concentrados;1;KG
1406;26080010;Sulfetos de minerios de zinco;1;KG
1407;26080090;Outros minerios de zinco e seus concentrados;1;KG
1408;26090000;Minerios de estanho e seus concentrados;1;KG
1409;26100010;Cromita (minerios de cromo);1;KG
1410;26100090;Outros minerios de cromo e seus concentrados;1;KG
1411;26110000;Minerios de tungstenio (volframio) e seus concentrados;1;KG
1412;26121000;Minerios de uranio e seus concentrados;1;KG
1413;26122000;Minerios de torio e seus concentrados;1;KG
1414;26131010;Molibdenita ustulada (minerios de molibdenio);1;KG
1415;26131090;Outros minerios de molibdenio, ustulados, seus concentrados;1;KG
1416;26139010;Molibdenita nao ustulada (minerios de molibdenio);1;KG
1417;26139090;Outros minerios de molibdenio nao ustulados e concentrados;1;KG
1418;26140010;Ilmenita (minerios de titanio);1;KG
1419;26140090;Outros minerios de titanio e seus concentrados;1;KG
1420;26151010;Badeleita (minerio de zirconio);1;KG
1421;26151020;Zirconita (minerio de zirconio);1;KG
1422;26151090;Outros minerios de zirconio e seus concentrados;1;KG
1423;26159000;Minerios de niobio, tantalo ou vanadio, seus concentrados;1;KG
1424;26161000;Minerios de prata e seus concentrados;1;KG
1425;26169000;Minerios de outros metais preciosos e seus concentrados;1;KG
1426;26171000;Minerios de antimonio e seus concentrados;1;KG
1427;26179000;Outros minerios e seus concentrados;1;KG
1428;26180000;Escoria de altos-fornos granulada (areia de escoria) proveniente da fabricacao de ferro fundido, ferro ou aco;1;KG
1429;26190000;Escorias (exceto escoria de altos-fornos granulada) e outros desperdicios da fabricacao de ferro fundido, ferro ou aco;1;KG
1430;26201100;Mates de galvanizacao (contendo zinco);1;KG
1431;26201900;Outras cinzas e residuos contendo zinco;1;KG
1432;26202100;Lamas de gasolina contendo chumbo, etc.;1;KG
1433;26202900;Outras cinzas e residuos contendo principalmente chumbo;1;KG
1434;26203000;Cinzas e residuos que contenham principalmente cobre;1;KG
1435;26204000;Cinzas e residuos que contenham principalmente aluminio;1;KG
1436;26206000;Cinzas e residuos, que contenham arsenio, mercurio, talio ou suas misturas, dos tipos utilizados para extracao de arsenio ou destes metais ou para fabricacao dos seus compostos quimicos;1;KG
1437;26209100;Cinzas e residuos, que contenham antimonio, berilio, cadmio, cromo ou suas misturas;1;KG
1438;26209910;Cinzas e residuos, que contenham principalmente titanio;1;KG
1439;26209990;Cinzas e residuos, contendo outros metais;1;KG
1440;26211000;Cinzas e residuos provenientes da incineracao de lixos municipais;1;KG
1441;26219010;Cinzas de origem vegetal;1;KG
1442;26219090;Outras escorias e cinzas;1;KG
1443;27011100;Hulha antracita, nao aglomerada;1;KG
1444;27011200;Hulha betuminosa, nao aglomerada;1;KG
1445;27011900;Outras hulhas, mesmo em po, mas nao aglomeradas;1;KG
1446;27012000;Briquetes, bolas em aglomerados, etc, obtidos da hulha;1;KG
1447;27021000;Linhitas, mesmo em po, mas nao aglomeradas;1;KG
1448;27022000;Linhitas aglomeradas;1;KG
1449;27030000;Turfa (incluindo a turfa para cama de animais), mesmo aglomerada;1;KG
1450;27040010;Coques de hulha, de linhita ou de turfa;1;KG
1451;27040090;Semicoques de hulha, linhita ou turfa, carvao de retorta;1;KG
1452;27050000;Gas de hulha, gas de agua, gas pobre (gas de ar) e gases semelhantes, exceto gases de petroleo e outros hidrocarbonetos gasosos;1;KG
1453;27060000;Alcatroes de hulha, de linhita ou de turfa e outros alcatroes minerais, mesmo desidratados ou parcialmente destilados, incluindo os alcatroes reconstituidos;1;KG
1454;27071000;Benzol (benzeno) (produtos da destilacao dos alcatroes de hulha);1;KG
1455;27072000;Toluol (tolueno) (produtos da destilacao dos alcatroes de hulha);1;KG
1456;27073000;Xilol (xilenos) (produtos da destilacao dos alcatroes de hulha);1;KG
1457;27074000;Naftaleno (produtos da destilacao dos alcatroes de hulha);1;KG
1458;27075000;Outras misturas de hidrocarbonetos aromaticos que destilem, incluindo as perdas, uma fracao igual ou superior a 65 %, em volume, a 250 �C, segundo o metodo ASTM D 86;1;KG
1459;27079100;Oleos de creosoto;1;KG
1460;27079910;Cresois;1;KG
1461;27079990;Outros oleos e produtos da destilacao do alcatrao de hulha;1;KG
1462;27081000;Breu obtido a partir do alcatrao de hulha ou de outros alcatroes minerais;1;KG
1463;27082000;Coque de breu obtido a partir do alcatrao de hulha ou de outros alcatroes minerais;1;KG
1464;27090010;Oleos brutos de petroleo;1;M3
1465;27090090;Oleos brutos de minerais betuminosos;1;M3
1466;27101210;Hexano comercial;1;KG
1467;27101221;Diisobutileno;1;KG
1468;27101229;Outras misturas de alquilidenos;1;KG
1469;27101230;Aguarras mineral (white spirit);1;KG
1470;27101241;Naftas para petroquimica;1;M3
1471;27101249;Outras naftas, exceto para petroquimica;1;M3
1472;27101251;Gasolinas para aviacao;1;M3
1473;27101259;Outras gasolinas, exceto para aviacao;1;M3
1474;27101260;Mistura de hidrocarbonetos aciclicos e ciclicos;1;KG
1475;27101290;Outros oleos leves e preparacoes;1;KG
1476;27101911;Querosenes de aviacao;1;M3
1477;27101919;Outros querosenes;1;M3
1478;27101921;Gasoleo (oleo diesel);1;M3
1479;27101922;Fuel oil;1;M3
1480;27101929;Outros oleos combustiveis;1;M3
1481;27101931;Oleos lubrificantes sem aditivos;1;KG
1482;27101932;Oleos lubrificantes com aditivos;1;KG
1483;27101991;Oleos minerais brancos (oleos de vaselina ou de parafina);1;KG
1484;27101992;Liquidos para transmissoes hidraulicas;1;KG
1485;27101993;Oleos para isolamento eletrico;1;KG
1486;27101994;Mistura de hidrocarbonetos aciclicos e ciclicos, saturados, derivados de fracoes de petroleo, contendo, em peso, < 2 %, de hidrocarbonetos aromaticos, que destila, segundo o metodo ASTM D 86, uma fracao < 90 %, em volume, a 210 �C, ponto final < 360 �C;1;KG
1487;27101999;Outros oleos de petroleo ou de minerais betuminosos;1;KG
1488;27102000;Oleos de petroleo ou minerais betuminosos (exceto oleo bruto);1;KG
1489;27109100;Residuos de oleos que contenham difenilas policloradas (PCB), terfenilas policloradas (PCT) ou difenilas polibromadas (PBB);1;KG
1490;27109900;Outros residuos de oleos;1;KG
1491;27111100;Gas natural liquefeito;1;KG
1492;27111210;Propano em bruto, liquefeito;1;KG
1493;27111290;Outros propanos liquefeitos;1;KG
1494;27111300;Butanos liquefeitos;1;KG
1495;27111400;Etileno, propileno, butileno e butadieno, liquefeitos;1;KG
1496;27111910;Gas liquefeito de petroleo (glp);1;KG
1497;27111990;Outros gases liquefeitos de hidrocarbonetos gasosos;1;KG
1498;27112100;Gas natural no estado gasoso;1;KG
1499;27112910;Butanos no estado gasoso;1;KG
1500;27112990;Outros hidrocarbonetos gasosos e gas petroleo, no estado gasoso;1;KG
1501;27121000;Vaselina;1;KG
1502;27122000;Parafina contendo peso < 0.75% de oleo;1;KG
1503;27129000;Cera de petroleo microcristalina, ceras minerais, etc.;1;KG
1504;27131100;Coque de petroleo nao calcinado;1;KG
1505;27131200;Coque de petroleo calcinado;1;KG
1506;27132000;Betume de petroleo;1;KG
1507;27139000;Outros residuos dos oleos de petroleo ou de minerais betuminosos;1;KG
1508;27141000;Xistos e areias betuminosos;1;KG
1509;27149000;Betumes, asfaltos naturais, asfaltitas, rochas asfalticas;1;KG
1510;27150000;Misturas betuminosas a base de asfalto ou de betume naturais, de betume de petroleo, de alcatrao mineral ou de breu de alcatrao mineral (por exemplo, mastiques betuminosos e cut-backs);1;KG
1511;27160000;Energia eletrica;1;MWHORA
1512;28011000;Cloro;1;KG
1513;28012010;Iodo sublimado;1;KG
1514;28012090;Outras formas de iodo;1;KG
1515;28013000;Fluor e bromo;1;KG
1516;28020000;Enxofre sublimado ou precipitado, enxofre coloidal;1;KG
1517;28030011;Negros de acetileno (negros de carbono);1;KG
1518;28030019;Outros negros de carbono;1;KG
1519;28030090;Outras formas de carbono;1;KG
1520;28041000;Hidrogenio;1;M3
1521;28042100;Argonio (gases raros);1;M3
1522;28042910;Helio liquido (gases raros);1;M3
1523;28042990;Outros gases raros;1;M3
1524;28043000;Nitrogenio (azoto);1;M3
1525;28044000;Oxigenio;1;M3
1526;28045000;Boro, telurio;1;KG
1527;28046100;Silicio, que contenham, em peso, pelo menos 99,99 % de silicio;1;KG
1528;28046900;Outros silicios;1;KG
1529;28047010;Fosforo branco;1;KG
1530;28047020;Fosforo vermelho ou amorfo;1;KG
1531;28047030;Fosforo negro;1;KG
1532;28048000;Arsenio;1;KG
1533;28049000;Selenio;1;KG
1534;28051100;Sodio (metal alcalino);1;KG
1535;28051200;Calcio;1;KG
1536;28051910;Estroncio;1;KG
1537;28051920;Bario;1;KG
1538;28051990;Outros metais alcalinos ou alcalinoterrosos;1;KG
1539;28053010;Liga de cerio, com teor de ferro inferior ou igual a 5 %, em peso (Mischmetal);1;KG
1540;28053090;Outros metais de terras raras, escandio e itrio;1;KG
1541;28054000;Mercurio;1;KG
1542;28061010;Cloreto de hidrogenio (acido cloridrico), em estado gasoso ou liquefeito;1;KG
1543;28061020;Cloreto de hidrogenio (acido cloridrico), em solucao aquosa;1;KG
1544;28062000;Acido clorossulfurico;1;KG
1545;28070010;Acido sulfurico;1;KG
1546;28070020;Acido sulfurico fumante (oleum);1;KG
1547;28080010;Acido nitrico;1;KG
1548;28080020;Acidos sulfonitricos;1;KG
1549;28091000;Pentoxido de difosforo;1;KG
1550;28092011;Acido fosforico com teor de ferro inferior a 750 ppm;1;KG
1551;28092019;Outros acidos fosforicos;1;KG
1552;28092020;Acido metafosforico;1;KG
1553;28092030;Acido pirofosforico;1;KG
1554;28092090;Outros acidos polifosforicos;1;KG
1555;28100010;Acido ortoborico;1;KG
1556;28100090;Oxidos de boro e outros acidos boricos;1;KG
1557;28111100;Fluoreto de hidrogenio (acido fluoridrico);1;KG
1558;28111200;Cianeto de hidrogenio (acido cianidrico ou acido hidrocianico);1;KG
1559;28111910;Acido aminossulfonico (acido sulfamico);1;KG
1560;28111920;Acido fosfonico (acido fosforoso);1;KG
1561;28111930;Acido perclorico;1;KG
1562;28111940;Fluoracidos e outros compostos de fluor;1;KG
1563;28111990;Outros acidos inorganicos;1;KG
1564;28112100;Dioxido de carbono;1;KG
1565;28112210;Dioxido de silicio obtido por precipitacao quimica;1;KG
1566;28112220;Dioxido de silicio tipo aerogel;1;KG
1567;28112230;Gel de silica (dioxido de silicio);1;KG
1568;28112290;Outros dioxidos de silicio;1;KG
1569;28112910;Dioxido de enxofre;1;KG
1570;28112990;Outros compostos oxigenados inorganicos de elemento nao metal;1;KG
1571;28121100;Dicloreto de carbonila (fosgenio);1;KG
1572;28121200;Oxicloreto de fosforo;1;KG
1573;28121300;Tricloreto de fosforo;1;KG
1574;28121400;Pentacloreto de fosforo;1;KG
1575;28121500;Monocloreto de enxofre;1;KG
1576;28121600;Dicloreto de enxofre;1;KG
1577;28121700;Cloreto de tionila;1;KG
1578;28121911;Tricloreto de arsenio;1;KG
1579;28121919;Outros halogenetos e oxialogenetos dos elementos nao-metalicos;1;KG
1580;28121920;Oxicloretos;1;KG
1581;28129000;Outros halogenetos, oxialogenetos dos elementos nao metalicos;1;KG
1582;28131000;Dissulfeto de carbono;1;KG
1583;28139010;Pentassulfeto de difosforo;1;KG
1584;28139090;Outros sulfetos dos elementos nao metalicos, e trissulf.fosforo com.;1;KG
1585;28141000;Amoniaco anidro;1;KG
1586;28142000;Amoniaco em solucao aquosa (amonia);1;KG
1587;28151100;Hidroxido de sodio (soda caustica), solido;1;KG
1588;28151200;Hidroxido de sodio (soda caustica), em solucao aquosa (lixivia de soda caustica);1;KG
1589;28152000;Hidroxido de potassio (potassa caustica);1;KG
1590;28153000;Peroxidos de sodio ou de potassio;1;KG
1591;28161010;Hidroxido de magnesio;1;KG
1592;28161020;Peroxido de magnesio;1;KG
1593;28164010;Hidroxido de bario;1;KG
1594;28164090;Oxidos, hidroxidos, peroxidos de estroncio, etc.;1;KG
1595;28170010;Oxido de zinco (branco de zinco);1;KG
1596;28170020;Peroxido de zinco;1;KG
1597;28181010;Corindo artificial, de constituicao quimica definida ou nao, branco, que passe atraves de uma peneira com abertura de malha de 63 micrometros (microns) em proporcao superior a 90 %, em peso;1;KG
1598;28181090;Outros corindos artificiais, de constituicao quimica definida ou nao;1;KG
1599;28182010;Alumina calcinada;1;KG
1600;28182090;Outros oxidos de aluminio;1;KG
1601;28183000;Hidroxido de aluminio;1;KG
1602;28191000;Trioxido de cromo;1;KG
1603;28199010;Oxidos de cromo;1;KG
1604;28199020;Hidroxidos de cromo;1;KG
1605;28201000;Dioxido de manganes;1;KG
1606;28209010;Oxido manganoso;1;KG
1607;28209020;Trioxido de dimanganes (sesquioxido de manganes);1;KG
1608;28209030;Tetraoxido de trimanganes (oxido salino de manganes);1;KG
1609;28209040;Heptaoxido de dimanganes (anidrido permanganico);1;KG
1610;28211011;Oxido ferrico, com teor de Fe2O3 superior ou igual a 85 %, em peso;1;KG
1611;28211019;Outros oxidos ferricos;1;KG
1612;28211020;Oxido ferroso-ferrico (oxido magnetico de ferro), com teor de Fe3O4 superior ou igual a 93 %, em peso;1;KG
1613;28211030;Hidroxidos de ferro;1;KG
1614;28211090;Outros oxidos de ferro;1;KG
1615;28212000;Terras corantes, peso >= 70% de ferro combinado, em fe2o3;1;KG
1616;28220010;Tetraoxido de tricobalto (oxido salino de cobalto);1;KG
1617;28220090;Outros oxidos e hidroxidos de cobalto, inclusive os comerciais;1;KG
1618;28230010;Oxidos de titanio, tipo anatase;1;KG
1619;28230090;Outros oxidos de titanio;1;KG
1620;28241000;Monoxido de chumbo (litargirio, massicote);1;KG
1621;28249010;Minio (zarcao) e minio-laranja (mine-orange);1;KG
1622;28249090;Outros oxidos de chumbo;1;KG
1623;28251010;Hidrazina e seus sais inorganicos;1;KG
1624;28251020;Hidroxilamina e seus sais inorganicos;1;KG
1625;28252010;Oxido de litio;1;KG
1626;28252020;Hidroxido de litio;1;KG
1627;28253010;Pentoxido de divanadio;1;KG
1628;28253090;Outros oxidos e hidroxidos de vanadio;1;KG
1629;28254010;Oxido niqueloso;1;KG
1630;28254090;Outros oxidos e hidroxidos de niquel;1;KG
1631;28255010;Oxido cuprico, com teor de CuO superior ou igual a 98 %, em peso;1;KG
1632;28255090;Outros oxidos e hidroxidos de cobre;1;KG
1633;28256010;Oxidos de germanio;1;KG
1634;28256020;Dioxido de zirconio;1;KG
1635;28257010;Trioxido de molibdenio;1;KG
1636;28257090;Outros oxidos e hidroxidos de molibdenio;1;KG
1637;28258010;Trioxido de antimonio;1;KG
1638;28258090;Outros oxidos de antimonio;1;KG
1639;28259010;Oxido de cadmio;1;KG
1640;28259020;Trioxido de tungstenio (volframio);1;KG
1641;28259090;Oxidos, hidroxidos e peroxidos de outros metais, etc.;1;KG
1642;28261200;Fluoretos de aluminio;1;KG
1643;28261910;Trifluoreto de cromo;1;KG
1644;28261920;Fluoreto acido de amonio;1;KG
1645;28261990;Outros fluoretos;1;KG
1646;28263000;Hexafluoraluminato de sodio (criolita sintetica);1;KG
1647;28269010;Fluoraluminato de potassio;1;KG
1648;28269020;Fluossilicatos de sodio ou de potassio;1;KG
1649;28269090;Outros fluossilicatos, fluoraluminatos, sais complexos fluor;1;KG
1650;28271000;Cloreto de amonio;1;KG
1651;28272010;Cloreto de calcio, com teor de CaCl2 superior ou igual a 98 %, em peso, em base seca;1;KG
1652;28272090;Outros cloretos de calcio;1;KG
1653;28273110;Cloreto de magnesio, com teor de MgCl2 inferior a 98 %, em peso, e de calcio (Ca) inferior ou igual a 0,5 %, em peso;1;KG
1654;28273190;Outros cloretos de magnesio;1;KG
1655;28273200;Cloreto de aluminio;1;KG
1656;28273500;Cloreto de niquel;1;KG
1657;28273910;Cloreto de cobre i (cloreto cuproso, monocloreto cobre);1;KG
1658;28273920;Cloreto de titanio;1;KG
1659;28273940;Cloreto de zirconio;1;KG
1660;28273950;Cloreto de antimonio;1;KG
1661;28273960;Cloreto de litio;1;KG
1662;28273970;Cloreto de bismuto;1;KG
1663;28273991;Cloreto de cadmio;1;KG
1664;28273992;Cloreto de cesio;1;KG
1665;28273993;Cloreto de cromo;1;KG
1666;28273994;Cloreto de estroncio;1;KG
1667;28273995;Cloreto de manganes;1;KG
1668;28273996;Cloreto de ferro;1;KG
1669;28273997;Cloreto de cobalto;1;KG
1670;28273998;Cloreto de zinco;1;KG
1671;28273999;Outros cloretos;1;KG
1672;28274110;Oxicloretos de cobre;1;KG
1673;28274120;Hidroxicloretos de cobre;1;KG
1674;28274911;Oxicloretos de bismuto;1;KG
1675;28274912;Oxicloretos de zirconio;1;KG
1676;28274919;Outros oxicloretos;1;KG
1677;28274921;Hidroxicloretos de aluminio;1;KG
1678;28274929;Outros hidroxicloretos;1;KG
1679;28275100;Brometos de sodio ou de potassio;1;KG
1680;28275900;Outros brometos e oxibrometos;1;KG
1681;28276011;Iodetos de sodio;1;KG
1682;28276012;Iodetos de potassio;1;KG
1683;28276019;Outros iodetos;1;KG
1684;28276021;Oxiiodetos de potassio;1;KG
1685;28276029;Outros oxiiodetos;1;KG
1686;28281000;Hipoclorito de calcio comercial e outros hipocloritos de calcio;1;KG
1687;28289011;Hipocloritos de sodio;1;KG
1688;28289019;Outros hipocloritos;1;KG
1689;28289020;Clorito de sodio;1;KG
1690;28289090;Outros cloritos e hipobromitos;1;KG
1691;28291100;Cloratos de sodio;1;KG
1692;28291910;Cloratos de calcio;1;KG
1693;28291920;Cloratos de potassio;1;KG
1694;28291990;Outros cloratos;1;KG
1695;28299011;Bromatos de sodio;1;KG
1696;28299012;Bromatos de potassio;1;KG
1697;28299019;Outros bromatos;1;KG
1698;28299021;Perbromatos de sodio;1;KG
1699;28299022;Perbromatos de potassio;1;KG
1700;28299029;Outros perbromatos;1;KG
1701;28299031;Iodatos de potassio;1;KG
1702;28299032;Iodatos de calcio;1;KG
1703;28299039;Outros iodatos;1;KG
1704;28299040;Periodatos;1;KG
1705;28299050;Percloratos;1;KG
1706;28301010;Sulfeto de dissodio;1;KG
1707;28301020;Sulfeto de monossodio (hidrogenossulfeto de sodio);1;KG
1708;28309011;Sulfetos de molibdenio iv (dissulfeto de molibdenio);1;KG
1709;28309012;Sulfeto de bario;1;KG
1710;28309013;Sulfeto de potassio;1;KG
1711;28309014;Sulfeto de chumbo;1;KG
1712;28309015;Sulfeto de estroncio;1;KG
1713;28309016;Sulfeto de zinco;1;KG
1714;28309019;Outros sulfetos;1;KG
1715;28309020;Polissulfetos;1;KG
1716;28311011;Ditionitos (hidrossulfitos) de sodio estabilizados;1;KG
1717;28311019;Outros ditionitos (hidrossulfitos) de sodio;1;KG
1718;28311021;Sulfoxilatos de sodio, estabilizados com formaldeido;1;KG
1719;28311029;Outros sulfoxilatos de sodio;1;KG
1720;28319010;Ditionito de zinco;1;KG
1721;28319090;Outros ditionitos e sulfoxilatos;1;KG
1722;28321010;Sulfito de dissodio;1;KG
1723;28321090;Outros sulfitos de sodio;1;KG
1724;28322000;Outros sulfitos;1;KG
1725;28323010;Tiossulfato de amonio;1;KG
1726;28323020;Tiossulfato de sodio;1;KG
1727;28323090;Outros tiossulfatos;1;KG
1728;28331110;Sulfato dissodico anidro;1;KG
1729;28331190;Outros sulfatos dissodicos;1;KG
1730;28331900;Outros sulfatos de sodio;1;KG
1731;28332100;Sulfato de magnesio;1;KG
1732;28332200;Sulfato de aluminio;1;KG
1733;28332400;Sulfato de niquel;1;KG
1734;28332510;Sulfato cuproso;1;KG
1735;28332520;Sulfato cuprico;1;KG
1736;28332710;Sulfato de bario, com teor de BaSO4 superior ou igual a 97,5 %, em peso;1;KG
1737;28332790;Outros sulfatos de bario;1;KG
1738;28332910;Sulfato de antimonio;1;KG
1739;28332920;Sulfato de litio;1;KG
1740;28332930;Sulfato de estroncio;1;KG
1741;28332940;Sulfato ferroso;1;KG
1742;28332950;Sulfato neutro de chumbo;1;KG
1743;28332960;Sulfatos de cromo;1;KG
1744;28332970;Sulfatos de zinco;1;KG
1745;28332990;Outros sulfatos;1;KG
1746;28333000;Alumes;1;KG
1747;28334010;Peroxossulfato (persulfato) de sodio;1;KG
1748;28334020;Peroxossulfato (persulfato) de amonio;1;KG
1749;28334090;Outros peroxossulfatos (persulfatos);1;KG
1750;28341010;Nitrito de sodio;1;KG
1751;28341090;Outros nitritos;1;KG
1752;28342110;Nitrato de potassio, com teor de KNO3 inferior ou igual a 98 %, em peso;1;KG
1753;28342190;Outros nitratos de potassio;1;KG
1754;28342910;Nitrato de calci, com teor de nitrogenio (azoto) inferior ou igual a 16 %, em peso;1;KG
1755;28342930;Nitrato de aluminio;1;KG
1756;28342940;Nitrato de litio;1;KG
1757;28342990;Outros nitratos;1;KG
1758;28351011;Fosfinato (hipofosfito) de sodio;1;KG
1759;28351019;Outros fosfinatos (hipofosfitos);1;KG
1760;28351021;Fosfonato (fosfito) dibasico de chumbo;1;KG
1761;28351029;Outros fosfonatos (fosfitos);1;KG
1762;28352200;Fosfato mono ou dissodico;1;KG
1763;28352400;Fosfato de potassio;1;KG
1764;28352500;Hidrogeno-ortofosfato de calcio (fosfato dicalcico);1;KG
1765;28352600;Outros fosfatos de calcio;1;KG
1766;28352910;Fosfato de ferro;1;KG
1767;28352920;Fosfato de cobalto;1;KG
1768;28352930;Fosfato de cobre;1;KG
1769;28352940;Fosfato de cromo;1;KG
1770;28352950;Fosfato de estroncio;1;KG
1771;28352960;Fosfato de manganes;1;KG
1772;28352970;Fosfato de triamonio;1;KG
1773;28352980;Fosfato de trissodio;1;KG
1774;28352990;Outros fosfatos;1;KG
1775;28353110;Trifosfato de sodio (tripolifosfato de sodio), grau alimenticio, de acordo com o estabelecido pela Food and Agriculture Organization - Organizacao Mundial da Saude (FAO - OMS) ou pelo Food Chemical Codex (FCC);1;KG
1776;28353190;Outros trifosfatos de sodio (tripolifosfato de sodio);1;KG
1777;28353910;Metafosfatos de sodio;1;KG
1778;28353920;Pirofosfatos de sodio;1;KG
1779;28353930;Pirofosfato de zinco;1;KG
1780;28353990;Outros polifosfatos;1;KG
1781;28362010;Carbonato dissodico anidro;1;KG
1782;28362090;Outros carbonatos dissodicos;1;KG
1783;28363000;Hidrogenocarbonato (bicarbonato) de sodio;1;KG
1784;28364000;Carbonatos de potassio;1;KG
1785;28365000;Carbonato de calcio;1;KG
1786;28366010;Carbonato de bario, com um teor de BaCO3 superior ou igual a 98%, em peso;1;KG
1787;28366090;Outros carbonatos de bario;1;KG
1788;28369100;Carbonatos de litio;1;KG
1789;28369200;Carbonato de estroncio;1;KG
1790;28369911;Carbonatos de magnesio, de densidade aparente inferior a 200 kg/m3;1;KG
1791;28369912;Carbonato de zirconio;1;KG
1792;28369913;Carbonatos de amonio comercial e outros carbonatos de amonio;1;KG
1793;28369919;Outros carbonatos;1;KG
1794;28369920;Peroxocarbonatos (percarbonatos);1;KG
1795;28371100;Cianeto e oxicianeto de sodio;1;KG
1796;28371911;Cianeto de potassio;1;KG
1797;28371912;Cianeto de zinco;1;KG
1798;28371914;Cianeto de cobre i (cianeto cuproso);1;KG
1799;28371915;Cianeto de cobre ii (cianeto cuprico);1;KG
1800;28371919;Outros cianetos;1;KG
1801;28371920;Outros oxianetos;1;KG
1802;28372011;Ferrocianeto de sodio;1;KG
1803;28372012;Ferrocianeto de ferro ii (ferrocianeto ferroso);1;KG
1804;28372019;Outros ferrocianetos;1;KG
1805;28372021;Ferricianeto de potassio;1;KG
1806;28372022;Ferricianeto de ferro ii (ferricianeto ferroso);1;KG
1807;28372023;Ferricianeto de ferro iii (ferricianeto ferrico);1;KG
1808;28372029;Outros ferricianetos;1;KG
1809;28372090;Outros cianetos complexos;1;KG
1810;28391100;Metassilicatos de sodio;1;KG
1811;28391900;Outros silicatos de sodio;1;KG
1812;28399010;Silicato de magnesio;1;KG
1813;28399020;Silicato de aluminio;1;KG
1814;28399030;Silicato de zirconio;1;KG
1815;28399040;Silicato de chumbo;1;KG
1816;28399050;Silicato de potassio;1;KG
1817;28399090;Outros silicatos;1;KG
1818;28401100;Tetraborato dissodico (borax refinado) anidro;1;KG
1819;28401900;Outros tetraboratos dissodicos (borax refinado);1;KG
1820;28402000;Outros boratos;1;KG
1821;28403000;Peroxoboratos (perboratos);1;KG
1822;28413000;Dicromato de sodio;1;KG
1823;28415011;Cromato de amonio, dicromato de amonio;1;KG
1824;28415012;Cromato de potassio;1;KG
1825;28415013;Cromato de sodio;1;KG
1826;28415014;Dicromato de potassio;1;KG
1827;28415015;Cromato de zinco;1;KG
1828;28415016;Cromato de chumbo;1;KG
1829;28415019;Outros cromatos e dicromatos;1;KG
1830;28415020;Peroxocromatos;1;KG
1831;28416100;Permanganato de potassio;1;KG
1832;28416910;Manganitos;1;KG
1833;28416920;Manganatos;1;KG
1834;28416930;Outros permanganatos;1;KG
1835;28417010;Molibdato de amonio;1;KG
1836;28417020;Molibdato de sodio;1;KG
1837;28417090;Outros molibdatos;1;KG
1838;28418010;Tungstato (volframato) de amonio;1;KG
1839;28418020;Tungstato (volframato) de chumbo;1;KG
1840;28418090;Outros tungstatos (volframatos);1;KG
1841;28419011;Titanato de chumbo;1;KG
1842;28419012;Titanatos de bario ou de bismuto;1;KG
1843;28419013;Titanatos de calcio ou de estroncio;1;KG
1844;28419014;Titanato de magnesio;1;KG
1845;28419015;Titanatos de lantanio ou de neodimio;1;KG
1846;28419019;Outros titanatos;1;KG
1847;28419021;Ferrito de bario;1;KG
1848;28419022;Ferrito de estroncio;1;KG
1849;28419029;Outros ferritos e ferratos;1;KG
1850;28419030;Vanadatos;1;KG
1851;28419041;Estanato de bario;1;KG
1852;28419042;Estanato de bismuto;1;KG
1853;28419043;Estanato de calcio;1;KG
1854;28419049;Outros estanatos;1;KG
1855;28419050;Plumbatos;1;KG
1856;28419060;Antimoniatos;1;KG
1857;28419070;Zincatos;1;KG
1858;28419081;Aluminatos de sodio;1;KG
1859;28419082;Aluminato de magnesio;1;KG
1860;28419083;Aluminato de bismuto;1;KG
1861;28419089;Outros aluminatos;1;KG
1862;28419090;Outros sais dos acidos oxometalicos ou peroxometalicos;1;KG
1863;28421010;Zeolitas dos tipos utilizados como trocadores de ions para o tratamento de aguas;1;KG
1864;28421090;Silicatos duplos ou complexos, exceto zeolitas;1;KG
1865;28429000;Outros sais dos acidos ou peroxoacidos inorganicos;1;KG
1866;28431000;Metais preciosos no estado coloidal;1;KG
1867;28432100;Nitrato de prata;1;KG
1868;28432910;Vitelinato de prata;1;KG
1869;28432990;Outros compostos de prata;1;KG
1870;28433010;Sulfeto de ouro em dispersao de gelatina;1;KG
1871;28433090;Outros compostos de ouro, exclusivamente auranofina, etc.;1;KG
1872;28439011;Dexormaplatina, enloplatina, iproplatina, lobaplatina, miboplatina, ormaplatina, sebriplatina e zeniplatina, apresentados como medicamento;1;KG
1873;28439019;Dexormaplatina, enloplatina, iproplatina, lobaplatina, miboplatina, ormaplatina, sebriplatina e zeniplatina, apresentadas de outra forma;1;KG
1874;28439090;Outros compostos inorganicos/organicos, amalgamas, de metais preciosos;1;KG
1875;28441000;Uranio natural e seus compostos, ligas, dispersoes (incluindo os ceramais (cermets)), produtos ceramicos e misturas que contenham uranio natural ou compostos de uranio natural;1;KG
1876;28442000;Uranio enriquecido em U235 e seus compostos, plutonio e seus compostos, ligas, dispersoes (incluindo os ceramais (cermets)), produtos ceramicos e misturas que contenham uranio enriquecido em U235, plutonio ou compostos destes produtos;1;KG
1877;28443000;Uranio empobrecido em U235 e seus compostos, torio e seus compostos, ligas, dispersoes (incluindo os ceramais (cermets)), produtos ceramicos e misturas que contenham uranio empobrecido em U235, torio ou compostos destes produtos;1;KG
1878;28444010;Molibdenio 99 absorvido em alumina, apto para a obtencao de Tecnecio 99 (reativo de diagnostico para medicina nuclear);1;KG
1879;28444020;Cobalto 60;1;KG
1880;28444030;Iodo 131;1;KG
1881;28444090;Outros elementos, isotopos e compostos, radioativos, etc.;1;KG
1882;28445000;Elementos combustiveis, usados, de reatores nucleares;1;KG
1883;28451000;Agua pesada (oxido de deuterio);1;KG
1884;28459000;Outros isotopos e seus compostos inorganicos ou organicos;1;KG
1885;28461010;Oxido cerico;1;KG
1886;28461090;Outros compostos de cerio;1;KG
1887;28469010;Oxido de praseodimio;1;KG
1888;28469020;Cloretos dos demais metais das terras raras;1;KG
1889;28469030;Gadopentetato de dimeglumina;1;KG
1890;28469090;Outros compostos dos metais das terras raras, de itrio, etc;1;KG
1891;28470000;Peroxido de hidrogenio (agua oxigenada), mesmo solidificado com ureia;1;KG
1892;28491000;Carbonetos de constituicao quimica definida ou nao, de calcio;1;KG
1893;28492000;Carbonetos de constituicao quimica definida ou nao, de silicio;1;KG
1894;28499010;Carbonetos de constituicao quimica definida ou nao, de boro;1;KG
1895;28499020;Carbonetos de constituicao quimica definida ou nao, de tantalo;1;KG
1896;28499030;Carbonetos de constituicao quimica definida ou nao, de tungstenio (volframio);1;KG
1897;28499090;Outros carbonetos de constituicao quimica definida ou nao;1;KG
1898;28500010;Nitreto de boro;1;QUILAT
1899;28500020;Silicieto de calcio;1;KG
1900;28500090;Hidretos, azidas, boretos e outros nitretos e silicietos;1;KG
1901;28521011;Oxidos de mercurio, inorganicos;1;KG
1902;28521012;Cloreto de mercurio i (cloreto mercuroso);1;KG
1903;28521013;Cloreto de mercurio  ii (cloreto mercurico), para uso fotografico;1;KG
1904;28521014;Cloreto de mercurio ii (cloreto mercurico), em outro modo;1;KG
1905;28521019;Outros compostos inorganicos de mercurio;1;KG
1906;28521021;Acetato de mercurio;1;KG
1907;28521022;Timerosal;1;KG
1908;28521023;Estearato de mercurio;1;KG
1909;28521024;Lactato de mercurio;1;KG
1910;28521025;Salicilato de mercurio;1;KG
1911;28521029;Outros compostos organicos de mercurio;1;KG
1912;28529000;Outros compostos de mercurio;1;KG
1913;28531000;Cloreto de cianogenio (clorociano);1;KG
1914;28539011;Fosfetos, de constituicao quimica definida ou nao, de aluminio;1;KG
1915;28539012;Fosfetos, de constituicao quimica definida ou nao, de magnesio;1;KG
1916;28539013;Fosfetos, de constituicao quimica definida ou nao, de cobre (fosfetos de cobre), contendo mais de 15�%, em peso, de fosforo;1;KG
1917;28539019;Outros fosfetos, de constituicao quimica definida ou nao;1;KG
1918;28539020;Cianamida e seus derivados metalicos;1;KG
1919;28539030;Sulfocloretos de fosforo;1;KG
1920;28539090;Outros produtos da Posicao 28.53;1;KG
1921;29011000;Hidrocarbonetos aciclicos saturados;1;KG
1922;29012100;Etileno nao saturado;1;KG
1923;29012200;Propeno (propileno) nao saturado;1;KG
1924;29012300;Buteno (butileno) nao saturado e seus isomeros;1;KG
1925;29012410;Buta-1, 3-dieno nao saturado;1;KG
1926;29012420;Isopreno nao saturado;1;KG
1927;29012900;Outros hidrocarbonetos aciclicos nao saturados;1;KG
1928;29021100;Cicloexano;1;KG
1929;29021910;Limoneno;1;KG
1930;29021990;Outros hidrocarbonetos ciclanicos, ciclenicos, cicloterpenicos;1;KG
1931;29022000;Benzeno;1;KG
1932;29023000;Tolueno;1;KG
1933;29024100;O-xileno;1;KG
1934;29024200;M-xileno;1;KG
1935;29024300;P-xileno;1;KG
1936;29024400;Mistura de isomeros do xileno;1;KG
1937;29025000;Estireno;1;KG
1938;29026000;Etilbenzeno;1;KG
1939;29027000;Cumeno;1;KG
1940;29029010;Difenila (1,1-bifenila);1;KG
1941;29029020;Naftaleno;1;KG
1942;29029030;Antraceno;1;KG
1943;29029040;Alfa-metilestireno;1;KG
1944;29029090;Outros hidrocarbonetos ciclicos;1;KG
1945;29031110;Clorometano (cloreto de metila);1;KG
1946;29031120;Cloroetano (cloreto de etila);1;KG
1947;29031200;Diclorometano (cloreto de metileno);1;KG
1948;29031300;Cloroformio (triclorometano);1;KG
1949;29031400;Tetracloreto de carbono;1;KG
1950;29031500;Dicloreto de etileno (ISO) (1,2-dicloroetano);1;KG
1951;29031910;1,1,1-Tricloroetano (metilcloroformio);1;KG
1952;29031920;1,1,2-Tricloroetano;1;KG
1953;29031990;Outros derivados clorados saturados dos hidrocarbonetos aciclicos;1;KG
1954;29032100;Cloreto de vinila (cloroetileno);1;KG
1955;29032200;Tricloroetileno;1;KG
1956;29032300;Tetracloroetileno (percloroetileno);1;KG
1957;29032900;Outros derivados clorados nao saturados dos hidrocarbonetos aciclicos;1;KG
1958;29033100;Dibrometo de etileno (ISO) (1,2-dibromoetano);1;KG
1959;29033911;1,1,1,2-Tetrafluoroetano;1;KG
1960;29033912;1,1,3,3,3-Pentafluoro-2-(trifluorometil)prop-1-eno;1;KG
1961;29033919;Outros derivados fluorados;1;KG
1962;29033921;Bromometano;1;KG
1963;29033929;Outros derivados bromados;1;KG
1964;29033931;Iodoetano;1;KG
1965;29033932;Iodoformio;1;KG
1966;29033939;Outros derivados iodados;1;KG
1967;29037100;Clorodifluorometanos;1;KG
1968;29037200;Diclorotrifluoroetanos;1;KG
1969;29037300;Diclorofluoroetanos;1;KG
1970;29037400;Clorodifluoroetanos;1;KG
1971;29037500;Dicloropentafluoropropanos;1;KG
1972;29037600;Bromoclorodifluorometano, bromotrifluorometano e dibromotetrafluorometanos;1;KG
1973;29037711;Triclorofluorometano;1;KG
1974;29037712;Diclorodifluorometano;1;KG
1975;29037713;Clorotrifluorometano;1;KG
1976;29037721;Triclorotrifluoroetanos;1;KG
1977;29037722;Diclorotetrafluoroetanos e cloropentafluoroetano;1;KG
1978;29037723;Pentaclorofluoroetano;1;KG
1979;29037724;Tetraclorodifluoroetanos;1;KG
1980;29037731;Heptaclorofluoropropanos;1;KG
1981;29037732;Hexaclorodifluoropropanos;1;KG
1982;29037733;Pentaclorotrifluoropropanos;1;KG
1983;29037734;Tetraclorotetrafluoropropanos;1;KG
1984;29037735;Tricloropentafluoropropanos;1;KG
1985;29037736;Dicloroexafluoropropanos;1;KG
1986;29037737;Cloroeptafluoropropanos;1;KG
1987;29037790;Outros derivados peralogenados dos hidrocarbonetos aciclicos, com fluor e bromo;1;KG
1988;29037800;Outros derivados peralogenados;1;KG
1989;29037911;Clorofluoroetanos;1;KG
1990;29037912;Clorotetrafluoroetanos;1;KG
1991;29037919;Outros derivados peralogenados;1;KG
1992;29037920;Derivados metano, etano ou propano ,halogenado, com fluor e bromo;1;KG
1993;29037931;Halotano;1;KG
1994;29037939;Outros bromoclorotrifluoroetanos;1;KG
1995;29037990;Outros derivados peralogenados dos hidrocarbonetos aciclicos, contendo ao menos dois halogenios diferentes;1;KG
1996;29038110;Lindano;1;KG
1997;29038190;Outros 1,2,3,4,5,6-hexaclorocicloexano;1;KG
1998;29038210;Aldrin;1;KG
1999;29038220;Clordano;1;KG
2000;29038230;Heptacloro;1;KG
2001;29038300;Mirex (ISO);1;KG
2002;29038900;Outros derivados halogenados dos hidrocarbonetos ciclanicos, ciclenicos ou cicloterpenicos;1;KG
2003;29039110;Clorobenzeno;1;KG
2004;29039120;o-Diclorobenzeno;1;KG
2005;29039130;p-Diclorobenzeno;1;KG
2006;29039210;Hexaclorobenzeno;1;KG
2007;29039220;DDT;1;KG
2008;29039300;Pentaclorobenzeno (ISO);1;KG
2009;29039400;Hexabromobifenilas;1;KG
2010;29039911;Cloreto de benzila;1;KG
2011;29039912;p-Clorotolueno;1;KG
2012;29039913;Cloreto de neofila;1;KG
2013;29039914;Triclorobenzenos;1;KG
2014;29039915;Cloronaftalenos;1;KG
2015;29039916;Cloreto de benzilideno;1;KG
2016;29039917;Cloretos de xilila;1;KG
2017;29039918;Bifenilas policloradas (PCB), terfenilas policloradas (PCT);1;KG
2018;29039919;Outros derivados halogenados, unicamente com cloro;1;KG
2019;29039921;Bromobenzeno;1;KG
2020;29039922;Brometos de xilila;1;KG
2021;29039923;Bromodifenilmetano;1;KG
2022;29039924;Bifenilas polibromadas (PBB);1;KG
2023;29039929;Outros derivados halogenados, unicamente com bromo;1;KG
2024;29039931;4-Cloro-alfa,alfa,alfa-trifluortolueno;1;KG
2025;29039939;Outros derivados halogenados, unicamente com fluor/cloro;1;KG
2026;29039990;Outros derivados halogenados;1;KG
2027;29041011;Acido metanossulfonico;1;KG
2028;29041012;Metanossulfonato de chumbo;1;KG
2029;29041013;Metanossulfonato de estanho;1;KG
2030;29041019;Outros derivados do acido metanossulfonico e seus sais;1;KG
2031;29041020;Acido dodecilbenzenossulfonico e seus sais;1;KG
2032;29041030;Acidos toluenossulfonicos, acidos xilenossulfonicos, sais destes acidos;1;KG
2033;29041040;Acido etanossulfonico, acido etilenossulfonico;1;KG
2034;29041051;Naftalenossulfonatos de sodio;1;KG
2035;29041052;Acido beta-naftalenossulfonico;1;KG
2036;29041053;Acidos alquil- e dialquilnaftalenossulfonicos, sais destes acidos;1;KG
2037;29041059;Outros acidos naftalenossulfonicos, sais, esteres etilicos;1;KG
2038;29041060;Acido benzenossulfonico e seus sais;1;KG
2039;29041090;Outros derivados sulfonados dos hidrocarbonetos, sais, etc.;1;KG
2040;29042010;Mononitrotoluenos (MNT);1;KG
2041;29042020;Nitropropanos;1;KG
2042;29042030;Dinitrotoluenos;1;KG
2043;29042041;2,4,6-Trinitrotolueno (TNT);1;KG
2044;29042049;Outros trinitrotoluenos;1;KG
2045;29042051;Nitrobenzeno;1;KG
2046;29042052;1,3,5-Trinitrobenzeno;1;KG
2047;29042059;Outros derivados nitrados do benzeno;1;KG
2048;29042060;Derivados nitrados do xileno;1;KG
2049;29042070;Mononitroetano, nitrometanos;1;KG
2050;29042090;Outros derivados nitrados ou nitrosados dos hidrocarbonetos;1;KG
2051;29043100;Acido perfluoroctano sulfonico;1;KG
2052;29043200;Perfluoroctanossulfonato de amonio;1;KG
2053;29043300;Perfluoroctanossulfonato de litio;1;KG
2054;29043400;Perfluoroctanossulfonato de potassio;1;KG
2055;29043500;Outros sais do acido perfluoroctano sulfonico;1;KG
2056;29043600;Fluoreto de perfluoroctanossulfonila;1;KG
2057;29049100;Tricloronitrometano (cloropicrina);1;KG
2058;29049911;1-Cloro-4-nitrobenzeno;1;KG
2059;29049912;1-Cloro-2,4-dinitrobenzeno;1;KG
2060;29049913;2-Cloro-1,3-dinitrobenzeno;1;KG
2061;29049914;4-Cloro-alfa,alfa,alfa-trifluor-3,5-dinitrotolueno;1;KG
2062;29049915;o-Nitroclorobenzeno, m-nitroclorobenzeno;1;KG
2063;29049916;1,2-Dicloro-4-nitrobenzeno;1;KG
2064;29049919;Outros derivados nitroalogenados;1;KG
2065;29049921;Acidos dinitroestilbenodissulfonicos;1;KG
2066;29049929;Outros derivados nitrossulfonados;1;KG
2067;29049930;Cloreto de p-toluenossulfonila (cloreto de tosila);1;KG
2068;29049940;Cloreto de o-toluenossulfonila;1;KG
2069;29049990;Outros derivados sulfonados, nitrados ou nitrosados dos hidrocarbonetos, mesmo halogenados;1;KG
2070;29051100;Metanol (alcool metilico);1;KG
2071;29051210;Alcool propilico;1;KG
2072;29051220;Alcool isopropilico;1;KG
2073;29051300;Butan-1-ol (alcool n-butilico);1;KG
2074;29051410;Alcool isobutilico (2-metil-1-propanol);1;KG
2075;29051420;Alcool sec-butilico (2-butanol);1;KG
2076;29051430;Alcool ter-butilico (2-metil-2-propanol);1;KG
2077;29051600;Octanol (alcool octilico) e seus isomeros;1;KG
2078;29051710;Alcool laurico;1;KG
2079;29051720;Alcool cetilico;1;KG
2080;29051730;Alcool estearico;1;KG
2081;29051911;n-Decanol;1;KG
2082;29051912;Isodecanol;1;KG
2083;29051919;Outros decanois, saturados;1;KG
2084;29051921;Etilato de magnesio;1;KG
2085;29051922;Metilato de sodio;1;KG
2086;29051923;Etilato de sodio;1;KG
2087;29051929;Outros alcoolatos metalicos;1;KG
2088;29051991;4-metilpentan-2-ol;1;KG
2089;29051992;Isononanol;1;KG
2090;29051993;Isotridecanol;1;KG
2091;29051994;Tetraidrolinalol (3,7-dimetiloctan-3-ol);1;KG
2092;29051995;3,3-Dimetilbutan-2-ol (alcool pinacolilico);1;KG
2093;29051996;Pentanol (alcool amilico) e seus isomeros;1;KG
2094;29051999;Outros monoalcoois saturados;1;KG
2095;29052210;Linalol;1;KG
2096;29052220;Geraniol;1;KG
2097;29052230;Diidromircenol (2,6-dimetil-7-octen-2-ol);1;KG
2098;29052290;Outros alcoois terpenicos aciclicos, nao saturados;1;KG
2099;29052910;Alcool alilico;1;KG
2100;29052990;Outros monoalcoois nao saturados;1;KG
2101;29053100;Etilenoglicol (etanodiol);1;KG
2102;29053200;Propilenoglicol (propano-1, 2-diol);1;KG
2103;29053910;2-Metil-2,4-pentanodiol (hexilenoglicol);1;KG
2104;29053920;Trimetilenoglicol (1, 3-propanodiol);1;KG
2105;29053930;1,3-Butilenoglicol (1,3-butanodiol);1;KG
2106;29053990;Outros alcoois diois, nao saturados;1;KG
2107;29054100;2-Etil-2-(hidroximetil)propano-1,3-diol (trimetilolpropano);1;KG
2108;29054200;Pentaeritritol (pentaeritrita);1;KG
2109;29054300;Manitol;1;KG
2110;29054400;D-glucitol (sorbitol) (polialcool);1;KG
2111;29054500;Glicerol;1;KG
2112;29054900;Outros polialcoois, nao saturados;1;KG
2113;29055100;Etclorvinol (DCI);1;KG
2114;29055910;Hidrato de cloral;1;KG
2115;29055990;Outros derivados hidrogenados, etc, dos alcoois aciclicos;1;KG
2116;29061100;Mentol;1;KG
2117;29061200;Cicloexanol, metilcicloexanois e dimetilcicloexanois;1;KG
2118;29061300;Esterois e inositois;1;KG
2119;29061910;Derivados do mentol;1;KG
2120;29061920;Borneol e isoborneol;1;KG
2121;29061930;Terpina e seu hidrato;1;KG
2122;29061940;Alcool fenchilico (1, 3, 3-trimetil-2-norbornanol);1;KG
2123;29061950;Terpineois;1;KG
2124;29061990;Outros alcoois ciclanicos, ciclenicos e cicloterpenicos;1;KG
2125;29062100;Alcool benzilico;1;KG
2126;29062910;2-feniletanol;1;KG
2127;29062920;Dicofol;1;KG
2128;29062990;Outros alcoois ciclicos aromaticos e seus derivados;1;KG
2129;29071100;Fenol (hidroxibenzeno) e seus sais;1;KG
2130;29071200;Cresois e seus sais;1;KG
2131;29071300;Octilfenol, nonilfenol, e seus isomeros, sais destes produtos;1;KG
2132;29071510;beta-Naftol e seus sais;1;KG
2133;29071590;Outros naftois e seus sais;1;KG
2134;29071910;2,6-Di-ter-butil-p-cresol e seus sais;1;KG
2135;29071920;o-Fenilfenol e seus sais;1;KG
2136;29071930;p-ter-Butilfenol e seus sais;1;KG
2137;29071940;Xilenois e seus sais;1;KG
2138;29071990;Outros monofenois;1;KG
2139;29072100;Resorcinol e seus sais;1;KG
2140;29072200;Hidroquinona e seus sais;1;KG
2141;29072300;4,4-Isopropilidenodifenol (bisfenol A, difenilolpropano) e seus sais;1;KG
2142;29072900;Outros polifenois;1;KG
2143;29081100;Pentaclorofenol (ISO) e seus sais;1;KG
2144;29081911;4-Cloro-m-cresol e seus sais;1;KG
2145;29081912;Diclorofenois e seus sais;1;KG
2146;29081913;p-Clorofenol;1;KG
2147;29081914;Triclorofenois e seus sais;1;KG
2148;29081915;Tetraclorofenois e seus sais;1;KG
2149;29081919;Outros derivados halogenados e seus sais, com cloro;1;KG
2150;29081921;2,4,6-Tribromofenol;1;KG
2151;29081929;Outros derivados halogenados e seus sais, com bromo;1;KG
2152;29081990;Outros derivados halogenados e seus sais;1;KG
2153;29089100;Dinoseb (ISO) e seus sais;1;KG
2154;29089200;4,6-dinitro-o-cresol (dnoc (iso)) e seus sais;1;KG
2155;29089912;p-Nitrofenol e seus sais;1;KG
2156;29089913;Acido picrico;1;KG
2157;29089919;Outros derivados nitrados e seus sais;1;KG
2158;29089921;Disofenol;1;KG
2159;29089929;Outros derivados nitroalogenados;1;KG
2160;29089930;Derivados sulfonados de fenol, seus sais e seus esteres;1;KG
2161;29089990;Outros derivados halogenados, sulfonados, nitrados ou nitrosados dos fenois ou dos fenois-alcoois;1;KG
2162;29091100;Eter dietilico (oxido de dietila);1;KG
2163;29091910;Eter metil-ter-butilico (MTBE);1;KG
2164;29091990;Outros eteres aciclicos e seus derivados halogenados, etc.;1;KG
2165;29092000;Eteres ciclanicos, ciclenicos, cicloterpenicos e seus derivados halogenados, sulfonados, nitrados ou nitrosados;1;KG
2166;29093011;Anetol;1;KG
2167;29093012;Eter difenilico (eter fenilico);1;KG
2168;29093013;Eter dibenzilico (eter benzilico);1;KG
2169;29093014;Eter feniletil-isoamilico;1;KG
2170;29093019;Outros eteres aromaticos;1;KG
2171;29093021;Oxifluorfeno;1;KG
2172;29093029;Outros derivados halogenados, etc, dos eteres aromaticos;1;KG
2173;29094100;2,2-Oxidietanol (dietilenoglicol);1;KG
2174;29094310;Eteres monobutilicos do etilenoglicol;1;KG
2175;29094320;Eteres monobutilicos do dietilenoglicol;1;KG
2176;29094411;Eter etilico do etilenoglicol;1;KG
2177;29094412;Eter isobutilico do etilenoglicol;1;KG
2178;29094413;Eter hexilico do etilenoglicol;1;KG
2179;29094419;Outros eteres monoalquilicos do etilenoglicol;1;KG
2180;29094421;Eter etilico do dietilenoglicol;1;KG
2181;29094429;Outros eteres monoalquilicos do dietilenoglicol;1;KG
2182;29094910;Guaifenesina;1;KG
2183;29094921;Trietilenoglicol;1;KG
2184;29094922;Tetraetilenoglicol;1;KG
2185;29094923;Pentaetilenoglicol e seus eteres;1;KG
2186;29094924;Eter fenilico do etilenoglicol;1;KG
2187;29094929;Outros etilenoglicois e seus eteres;1;KG
2188;29094931;Dipropilenoglicol;1;KG
2189;29094932;Eteres do mono-, di- e tripropilenoglicol;1;KG
2190;29094939;Outros propilenoglicois e seus eteres;1;KG
2191;29094941;Eter etilico do butilenoglicol;1;KG
2192;29094949;Butilenoglicois e outros eteres;1;KG
2193;29094950;Alcool fenoxibenzilico;1;KG
2194;29094990;Outros eteres-alcoois e seus derivados halogenados, etc.;1;KG
2195;29095011;Triclosan;1;KG
2196;29095012;Eugenol;1;KG
2197;29095013;Isoeugenol;1;KG
2198;29095019;Outros eteres-fenois;1;KG
2199;29095090;Eteres-alcoois-fenois e seus derivados halogenados, etc.;1;KG
2200;29096011;Hidroperoxido de diisopropilbenzeno;1;KG
2201;29096012;Hidroperoxido de ter-butila;1;KG
2202;29096013;Hidroperoxido de p-mentano;1;KG
2203;29096019;Outros hidroperoxidos de alcoois, eteres, cetonas e derivados;1;KG
2204;29096020;Peroxidos de alcoois, eteres, cetonas, derivados halogenados, etc.;1;KG
2205;29101000;Oxirano (oxido de etileno);1;KG
2206;29102000;Metiloxirano (oxido de propileno);1;KG
2207;29103000;1-cloro-2, 3-epoxipropano (epicloridrina);1;KG
2208;29104000;Dieldrin;1;KG
2209;29105000;Endrin (ISO);1;KG
2210;29109010;Oxido de estireno;1;KG
2211;29109090;Outros epoxidos, epoxialcoois, etc, com tres atomos no ciclo;1;KG
2212;29110010;Dimetilacetal do 2-nitrobenzaldeido;1;KG
2213;29110090;Outros acetais e hemiacetais, mesmo que contenham outras funcoes oxigenadas, e seus derivados halogenados, sulfonados, nitrados ou nitrosados;1;KG
2214;29121100;Metanal (formaldeido);1;KG
2215;29121200;Etanal (acetaldeido);1;KG
2216;29121911;Glioxal;1;KG
2217;29121912;Glutaraldeido;1;KG
2218;29121919;Outros dialdeidos;1;KG
2219;29121921;Citral;1;KG
2220;29121922;Citronelal (3,7-dimetil-6-octenal);1;KG
2221;29121923;Bergamal (3,7-dimetil-2-metileno-6-octenal);1;KG
2222;29121929;Outros monoaldeidos nao saturados;1;KG
2223;29121991;Heptanal;1;KG
2224;29121999;Outros aldeidos aciclicos nao contendo outras funcoes oxigenadas;1;KG
2225;29122100;Benzaldeido (aldeido benzoico);1;KG
2226;29122910;Aldeido alfa-amilcinamico;1;KG
2227;29122920;Aldeido alfa-hexilcinamico;1;KG
2228;29122990;Outros aldeidos ciclicos nao contendo outras funcoes oxigenadas;1;KG
2229;29124100;Vanilina (aldeido metilprotocatequico);1;KG
2230;29124200;Etilvanilina (aldeido etilprotocatequico);1;KG
2231;29124910;3-Fenoxibenzaldeido;1;KG
2232;29124920;3-Hidroxibenzaldeido;1;KG
2233;29124930;3,4,5-Trimetoxibenzaldeido;1;KG
2234;29124941;4-(4-Hidroxi-4-metilpentil)-3-cicloexeno-1-carboxialdeido;1;KG
2235;29124949;Outros aldeidos-alcoois;1;KG
2236;29124990;Outros aldeidos-eteres, aldeidos-fenois e com funcoes oxigenadas;1;KG
2237;29125000;Polimeros ciclicos dos aldeidos;1;KG
2238;29126000;Paraformaldeido;1;KG
2239;29130010;Tricloroacetaldeido;1;KG
2240;29130090;Outros derivados halogenados, sulfonados, etc, dos aldeidos;1;KG
2241;29141100;Acetonas que nao contenham outras funcoes oxigenadas;1;KG
2242;29141200;Butanona (metiletilcetona);1;KG
2243;29141300;4-Metilpentan-2-ona (metilisobutilcetona);1;KG
2244;29141910;Forona;1;KG
2245;29141921;Acetilacetona;1;KG
2246;29141922;Acetonilacetona;1;KG
2247;29141923;Diacetila;1;KG
2248;29141929;Outras dicetonas;1;KG
2249;29141930;Metilexilcetona;1;KG
2250;29141940;Pseudoiononas;1;KG
2251;29141950;Metilisopropilcetona;1;KG
2252;29141990;Outras cetonas aciclicas nao contendo outras funcoes oxigenadas;1;KG
2253;29142210;Cicloexanona;1;KG
2254;29142220;Metilcicloexanonas;1;KG
2255;29142310;Iononas;1;KG
2256;29142320;Metiliononas;1;KG
2257;29142910;Carvona;1;KG
2258;29142920;1-mentona;1;KG
2259;29142990;Outras cetonas ciclanicas, etc, nao contendo outras funcoes oxigenadas;1;KG
2260;29143100;Fenilacetona (fenilpropan-2-ona);1;KG
2261;29143910;Acetofenona;1;KG
2262;29143990;Outras cetonas aromaticas, nao contendo outras funcoes oxigenadas;1;KG
2263;29144010;4-hidroxi-4-metilpentano-2-ona (diacetona alcool);1;KG
2264;29144091;Benzoina;1;KG
2265;29144099;Outras cetonas-alcoois e cetonas-aldeidos;1;KG
2266;29145010;Nabumetona;1;KG
2267;29145020;1,8-Diidroxi-3-metil-9-antrona e sua forma enolica (crisarobina ou chrysarobin);1;KG
2268;29145090;Outras cetonas-fenois e cetonas contendo outras funcoes oxigenadas;1;KG
2269;29146100;Antraquinona;1;KG
2270;29146200;Coenzima Q10 (ubidecarenona (DCI));1;KG
2271;29146910;Lapachol;1;KG
2272;29146920;Menadiona;1;KG
2273;29146990;Outras quinonas;1;KG
2274;29147100;Clordecona (ISO);1;KG
2275;29147911;1-Cloro-5-hexanona;1;KG
2276;29147919;Outros derivados halogenados;1;KG
2277;29147921;Bissulfito sodico de menadiona;1;KG
2278;29147922;Acido 2-hidroxi-4-metoxibenzofenona-5-sulfonico (sulisobenzona);1;KG
2279;29147929;Outros derivados sulfonados;1;KG
2280;29147990;Outros derivados halogenados, nitrados ou nitrosados;1;KG
2281;29151100;Acido formico;1;KG
2282;29151210;Sal de sodio, do acido formico;1;KG
2283;29151290;Outros sais do acido formico;1;KG
2284;29151310;Ester de geranila, do acido formico;1;KG
2285;29151390;Outros esteres do acido formico;1;KG
2286;29152100;Acido acetico;1;KG
2287;29152400;Anidrido acetico;1;KG
2288;29152910;Acetato de sodio;1;KG
2289;29152920;Acetatos de cobalto;1;KG
2290;29152990;Outros sais do acido acetico;1;KG
2291;29153100;Acetato de etila;1;KG
2292;29153200;Acetato de vinila;1;KG
2293;29153300;Acetato de n-butila;1;KG
2294;29153600;Acetato de dinoseb;1;KG
2295;29153910;Acetato de linalila;1;KG
2296;29153921;Triacetina;1;KG
2297;29153929;Outros acetatos de glicerila;1;KG
2298;29153931;Acetato de n-propila;1;KG
2299;29153932;Acetato de 2-etoxietila;1;KG
2300;29153939;Outros acetatos monoalcoois aciclicos saturados, atomo de c <= 8;1;KG
2301;29153941;Acetato de decila;1;KG
2302;29153942;Acetato de hexenila;1;KG
2303;29153951;Acetato de benzestrol;1;KG
2304;29153952;Acetato de dienoestrol;1;KG
2305;29153953;Acetato de hexestrol;1;KG
2306;29153954;Acetato de mestilbol;1;KG
2307;29153955;Acetato de estildestrol;1;KG
2308;29153961;Acetato de tricloro-alfa-feniletila;1;KG
2309;29153962;Acetato de triclorometilfenilcarbinila;1;KG
2310;29153963;Diacetato de etilenoglicol (diacetato de etileno);1;KG
2311;29153991;Esteres de 2-ter-butilcicloexila;1;KG
2312;29153992;Esteres de bornila;1;KG
2313;29153993;Esteres de dimetilbenzilcarbinila;1;KG
2314;29153994;Bis(p-acetoxifenil)cicloexilidenometano (ciclofenil);1;KG
2315;29153999;Outros esteres do acido acetico;1;KG
2316;29154010;Acido monocloroacetico;1;KG
2317;29154020;Monocloroacetato de sodio;1;KG
2318;29154090;Acido di- ou tricloroacetico, seus sais e esteres;1;KG
2319;29155010;Acido propionico;1;KG
2320;29155020;Sais do acido propionico;1;KG
2321;29155030;Esteres do acido propionico;1;KG
2322;29156011;Acido butirico e seus sais;1;KG
2323;29156012;Butirato de etila;1;KG
2324;29156019;Outros esteres do acido butirico;1;KG
2325;29156021;Acido pivalico;1;KG
2326;29156029;Acido valerico e seus outros sais e esteres;1;KG
2327;29157011;Acido palmitico;1;KG
2328;29157019;Outros sais e esteres do acido palmitico;1;KG
2329;29157020;Acido estearico (acido monocarboxilico aciclico saturado);1;KG
2330;29157031;Sais de zinco do acido estearico;1;KG
2331;29157039;Outros sais do acido estearico;1;KG
2332;29157040;Esteres do acido estearico;1;KG
2333;29159010;Cloreto de cloroacetila;1;KG
2334;29159021;Acido 2-etilexanoico (acido 2-etilexoico);1;KG
2335;29159022;2-etilexanoato de estanho ii;1;KG
2336;29159023;Di(2-etilexanoato) de trietilenoglicol;1;KG
2337;29159024;Cloreto de 2-etilexanoila;1;KG
2338;29159029;Outros sais e esteres do acido 2-etilexanoico;1;KG
2339;29159031;Acido miristico;1;KG
2340;29159032;Acido caprilico;1;KG
2341;29159033;Miristato de isopropila;1;KG
2342;29159039;Outros sais e esteres dos acidos miristico ou caprilico;1;KG
2343;29159041;Acido laurico;1;KG
2344;29159042;Sais e esteres do acido laurico;1;KG
2345;29159050;Peroxidos dos acidos monocarboxilicos aciclicos saturados;1;KG
2346;29159060;Peracidos dos acidos monocarboxilicos aciclicos saturados;1;KG
2347;29159090;Outros acidos monocarboxilicos aciclicos saturados, etc.;1;KG
2348;29161110;Acido acrilico;1;KG
2349;29161120;Sais do acido acrilico;1;KG
2350;29161210;Esteres de metila do acido acrilico;1;KG
2351;29161220;Esteres de etila do acido acrilico;1;KG
2352;29161230;Esteres de butila do acido acrilico;1;KG
2353;29161240;Esteres de 2-etilexila do acido acrilico;1;KG
2354;29161290;Outros esteres do acido acrilico;1;KG
2355;29161310;Acido metacrilico;1;KG
2356;29161320;Sais do acido metacrilico;1;KG
2357;29161410;Esteres de metila do acido metacrilico;1;KG
2358;29161420;Esteres de etila do acido metacrilico;1;KG
2359;29161430;Esteres de n-butila do acido metacrilico;1;KG
2360;29161490;Outros esteres do acido metacrilico;1;KG
2361;29161511;Oleato de manitol;1;KG
2362;29161519;Acido oleico, outros sais e esteres (acido monocarboxilico aciclico);1;KG
2363;29161520;Acido linoleico e acido linonenico, seus sais e esteres;1;KG
2364;29161600;Binapacril (isso);1;KG
2365;29161911;Sorbato de potassio;1;KG
2366;29161919;Acido sorbico, seus outros sais e esteres;1;KG
2367;29161921;Acido undecilenico;1;KG
2368;29161922;Undecilinato de metila;1;KG
2369;29161923;Undecilenato de zinco;1;KG
2370;29161929;Outros sais e esteres do acido undecilenico;1;KG
2371;29161990;Outros acidos monocarboxilicos aciclicos nao saturados, etc.;1;KG
2372;29162011;Acido 3-(2,2-dibromovinil)-2,2-dimetilciclopropanocarboxilico;1;KG
2373;29162012;Cloreto do acido 3-(2,2-diclorovinil)-2,2-dimetilciclopropanocarboxilico (DVO);1;KG
2374;29162013;Aletrinas;1;KG
2375;29162014;Permetrina;1;KG
2376;29162015;Bifentrin;1;KG
2377;29162019;Outros derivados do acido ciclopropanocarboxilico;1;KG
2378;29162090;Outros acidos monocarboxilicos ciclanicos, ciclenicos, etc.;1;KG
2379;29163110;Acido benzoico;1;KG
2380;29163121;Sais de sodio do acido benzoico;1;KG
2381;29163122;Sais de amonio do acido benzoico;1;KG
2382;29163129;Outros sais do acido benzoico;1;KG
2383;29163131;Esteres de metila do acido benzoico;1;KG
2384;29163132;Esteres de benzila do acido benzoico;1;KG
2385;29163139;Outros esteres do acido benzoico;1;KG
2386;29163210;Peroxido de benzoila;1;KG
2387;29163220;Cloreto de benzoila;1;KG
2388;29163400;Acido fenilacetico e seus sais;1;KG
2389;29163910;Cloreto de 4-cloro-alfa-(1-metiletil) benzenoacetila;1;KG
2390;29163920;Ibuprofeno;1;KG
2391;29163930;Acido 4-cloro-3-nitrobenzoico;1;KG
2392;29163940;Perbenzoato de ter-butila;1;KG
2393;29163990;Outros acidos monocarboxilicos aromaticos, etc.;1;KG
2394;29171110;Acido oxalico e seus sais;1;KG
2395;29171120;Esteres do acido oxalico;1;KG
2396;29171210;Acido adipico;1;KG
2397;29171220;Sais e esteres do acido adipico;1;KG
2398;29171310;Acido azelaico, seus sais e esteres;1;KG
2399;29171321;Acido sebacico;1;KG
2400;29171322;Sebacato de dibutila;1;KG
2401;29171323;Sebacato de dioctila;1;KG
2402;29171329;Outros sais e esteres do acido sebacico;1;KG
2403;29171400;Anidrido maleico;1;KG
2404;29171910;Dioctilsulfossuccinato de sodio;1;KG
2405;29171921;Acido maleico;1;KG
2406;29171922;Sais e esteres do acido maleico;1;KG
2407;29171930;Acido fumarico, seus sais e esteres;1;KG
2408;29171990;Outros acidos policarboxilicos aciclicos, etc.;1;KG
2409;29172000;Acido policarboxilico ciclanico, ciclenico, etc.;1;KG
2410;29173200;Ortoftalatos de dioctila;1;KG
2411;29173300;Ortoftalatos de dinonila ou de didecila;1;KG
2412;29173400;Outros esteres do acido ortoftalico;1;KG
2413;29173500;Anidrido ftalico;1;KG
2414;29173600;Acido tereftalico e seus sais;1;KG
2415;29173700;Tereftalato de dimetila;1;KG
2416;29173911;Esteres do acido m-ftalico;1;KG
2417;29173919;Acido m-ftalico e seus sais;1;KG
2418;29173920;Acido ortoftalico e seus sais;1;KG
2419;29173931;Esteres de dioctila do acido tereftalico;1;KG
2420;29173939;Outros esteres do acido tereftalico;1;KG
2421;29173940;Sais e esteres do acido trimelitico (1, 2, 4-benzenotricarb);1;KG
2422;29173950;Anidrido trimelitico (acido 1, 3dioxo-5isobenzofuranocarb.);1;KG
2423;29173990;Outros acidos policarboxilicos aromaticos, etc.;1;KG
2424;29181100;Acido lactico, seus sais e esteres;1;KG
2425;29181200;Acido tartarico;1;KG
2426;29181310;Sais do acido tartarico;1;KG
2427;29181320;Esteres do acido tartarico;1;KG
2428;29181400;Acido citrico;1;KG
2429;29181500;Sais e esteres do acido citrico;1;KG
2430;29181610;Gluconato de calcio;1;KG
2431;29181690;Acido gluconico, seus outros sais e esteres;1;KG
2432;29181700;Acido 2,2-difenil-2-hidroxiacetico (acido benzilico);1;KG
2433;29181800;Clorobenzilato;1;KG
2434;29181910;Bromopropilato;1;KG
2435;29181921;Ursodiol (acido ursodeoxicolico);1;KG
2436;29181922;Acido quenodeoxicolico;1;KG
2437;29181929;Acido biliar, seus outros sais, esteres e derivados;1;KG
2438;29181930;Acido 12-hidroxiestearico;1;KG
2439;29181942;Sais do acido benzilico;1;KG
2440;29181943;Esteres do acido benzilico;1;KG
2441;29181990;Outros acidos carboxilicos funcao alcool, anidridos, etc.;1;KG
2442;29182110;Acido salicilico;1;KG
2443;29182120;Sais do acido salicilico;1;KG
2444;29182211;Acido o-acetilsalicilico;1;KG
2445;29182212;O-acetilsalicilato de aluminio;1;KG
2446;29182219;Outros sais do acido o-acetilsalicilico;1;KG
2447;29182220;Esteres do acido o-acetilsalicilico;1;KG
2448;29182300;Outros esteres do acido salicilico e seus sais;1;KG
2449;29182910;Acido hidroxinaftoico;1;KG
2450;29182921;Acido p-hidroxibenzoico;1;KG
2451;29182922;Metilparabeno;1;KG
2452;29182923;Propilparabeno;1;KG
2453;29182929;Outros sais e esteres do acido p-hidroxibenzoico;1;KG
2454;29182930;Acido galico, seus sais e esteres;1;KG
2455;29182940;Tetrakis(3-(3,5-di-ter-butil-4-hidroxifenil)propionato) de pentaeritritila;1;KG
2456;29182950;3-(3,5-Di-ter-butil-4-hidroxifenil)propionato de octadecila;1;KG
2457;29182990;Outros acidos carboxilicos funcao fenol, anidridos, etc.;1;KG
2458;29183010;Cetoprofeno;1;KG
2459;29183020;Butirilacetato de metila;1;KG
2460;29183031;Acido deidrocolico;1;KG
2461;29183032;Deidrocolato de sodio;1;KG
2462;29183033;Deidrocolato de magnesio;1;KG
2463;29183039;Outros sais do acido deidrocolico;1;KG
2464;29183040;Acetilacetato de 2-nitrometilbenzilideno;1;KG
2465;29183090;Outros acidos carboxilicos funcao aldeido, cetona, etc.;1;KG
2466;29189100;Acido 2, 4, 5-triclorofenoxiacetico;1;KG
2467;29189911;Acido fenoxiacetico, seus sais e seus esteres;1;KG
2468;29189912;Acido 2,4-diclorofenoxiacetico (2,4-D), seus sais e seus esteres;1;KG
2469;29189919;Outros derivados de acidos fenoxiaceticos, sais, esteres;1;KG
2470;29189921;Acidos diclorofenoxibutanoicos, seus sais e seus esteres;1;KG
2471;29189929;Outros acidos fenoxibutanoicos, seus sais e seus esteres, derivados destes produtos;1;KG
2472;29189930;Acifluorfen sodico;1;KG
2473;29189940;Naproxeno;1;KG
2474;29189950;Acido 3-(2-cloro-alfa, alfa, alfa-trifluor-p-toliloxi)benzoico;1;KG
2475;29189960;Diclofop-metila;1;KG
2476;29189991;Fenofibrato;1;KG
2477;29189992;Acidos metilclorofenoxiaceticos, seus sais e seus esteres;1;KG
2478;29189993;5-(2-Cloro-4-trifluorometilfenoxi)-2-nitrobenzoato de 1-(carboetoxi)etila (lactofen);1;KG
2479;29189994;Acido 4-(4-hidroxifenoxi)-3,5-diiodofenilacetico;1;KG
2480;29189999;Outros acidos carboxilicos que contenham funcoes oxigenadas suplementares e seus anidridos;1;KG
2481;29191000;Fosfato de tris(2, 3-dibromopropila);1;KG
2482;29199010;Esteres fosforicos e sais de tributila;1;KG
2483;29199020;Esteres fosforicos e sais de tricresila;1;KG
2484;29199030;Esteres fosforicos e sais de trifenila;1;KG
2485;29199040;Diclorvos (ddvp);1;KG
2486;29199050;Lactofosfato de calcio;1;KG
2487;29199060;Clorfenvinfos;1;KG
2488;29199090;Outros esteres fosforicos e seus sais, incluindo os lactofosfatos, seus derivados halogenados, sulfonados, nitrados ou nitrosados;1;KG
2489;29201110;Paration (etil paration);1;KG
2490;29201120;Paration-metila (metil paration);1;KG
2491;29201910;Fenitrotion;1;KG
2492;29201920;Cloreto de fosforotioato de dimetila;1;KG
2493;29201990;Outros esteres tiofosforicos, sais e derivados;1;KG
2494;29202100;Fosfito de dimetila;1;KG
2495;29202200;Fosfito de dietila;1;KG
2496;29202300;Fosfito de trimetila;1;KG
2497;29202400;Fosfito de trietila;1;KG
2498;29202910;Fosfito de alquila de C3 a C13 ou de alquil-arila;1;KG
2499;29202920;Fosfito de difenila;1;KG
2500;29202930;Outros fosfitos, de arila;1;KG
2501;29202940;Fosetil Al;1;KG
2502;29202950;Fosfito de tris(2,4-di-ter-butilfenila);1;KG
2503;29202990;Outros esteres de fosfitos e seus sais, seus derivados halogenados, sulfonados, nitrados ou nitrosados;1;KG
2504;29203000;Endossulfan (ISO);1;KG
2505;29209022;Propargite;1;KG
2506;29209029;Outros sulfitos de esteres de acidos inorganicos;1;KG
2507;29209031;Nitrato de propatila;1;KG
2508;29209032;Nitroglicerina;1;KG
2509;29209033;Tetranitrato de pentaeritritol (PETN, nitropenta, pentrita);1;KG
2510;29209039;Outros nitratos de esteres de acidos inorganicos;1;KG
2511;29209041;Sulfatos de alquila de C6 a C22;1;KG
2512;29209042;Sulfatos de monoalquildietilenoglicol ou de monoalquiltrietilenoglicol;1;KG
2513;29209049;Outros sulfatos de esteres de acidos inorganicos;1;KG
2514;29209051;Silicato de etila;1;KG
2515;29209059;Outros silicatos de esteres de acidos inorganicos;1;KG
2516;29209090;Outros esteres dos acidos inorganicos, sais, derivados halogenados, etc;1;KG
2517;29211111;Monometilamina;1;KG
2518;29211112;Sais de monometilamina;1;KG
2519;29211121;Dimetilamina;1;KG
2520;29211122;2, 4-diclorofenoxiacetato de dimetilamina;1;KG
2521;29211123;Metilclorofenoxiacetato de dimetilamina;1;KG
2522;29211129;Outros sais de dimetilamina;1;KG
2523;29211131;Trimetilamina;1;KG
2524;29211132;Cloridrato de trimetilamina;1;KG
2525;29211139;Outros sais de trimetilamina;1;KG
2526;29211200;Cloridrato de 2-cloroetil(N,N-dimetilamina);1;KG
2527;29211300;Cloridrato de 2-cloroetil(N,N-dietilamina);1;KG
2528;29211400;Cloridrato de 2-cloroetil(N,N-diisopropilamina);1;KG
2529;29211911;Monoetilamina e seus sais;1;KG
2530;29211912;Trietilamina;1;KG
2531;29211913;Bis (2-cloroetil) etilamina;1;KG
2532;29211914;Triclormetina (tris(2-cloroetil)amina);1;KG
2533;29211915;Dietilamina sais, exceto etansilato (ethamsylate);1;KG
2534;29211919;Outras etilaminas, seus derivados e seus sais;1;KG
2535;29211921;Mono-n-propilamina e seus sais;1;KG
2536;29211922;Di-n-propilamina e seus sais;1;KG
2537;29211923;Monoisopropilamina e seus sais;1;KG
2538;29211924;Diisopropilamina e seus sais;1;KG
2539;29211929;Outras n-propilaminas, isopropilaminas e seus sais;1;KG
2540;29211931;Diisobutilamina e seus sais;1;KG
2541;29211939;Outras butilaminas e seus sais;1;KG
2542;29211941;Metildialquilaminas;1;KG
2543;29211949;Monoalquil- e outras dialquilaminas, alquila de c10 a c18;1;KG
2544;29211991;Clormetina (DCI) (bis(2-cloroetil)metilamina);1;KG
2545;29211992;N,N-Dialquil-2-cloroetilamina, com grupos alquila de C1 a C3, e seus sais protonados;1;KG
2546;29211993;Mucato de isometepteno;1;KG
2547;29211999;Outras monoaminas aciclicas e seus derivados e seus sais;1;KG
2548;29212100;Etilenodiamina e seus sais;1;KG
2549;29212200;Hexametilenodiamina e seus sais;1;KG
2550;29212910;Dietilenotriamina e seus sais;1;KG
2551;29212920;Trietilenotetramina e seus sais;1;KG
2552;29212990;Outras poliaminas aciclicas, seus derivados e seus sais;1;KG
2553;29213011;Monocicloexilamina e seus sais;1;KG
2554;29213012;Dicicloexilamina;1;KG
2555;29213019;Outras cicloexilaminas e seus sais;1;KG
2556;29213020;Propilexedrina;1;KG
2557;29213090;Outras monoaminas e poliaminas ciclanicas, ciclenicas, etc.;1;KG
2558;29214100;Anilina e seus sais;1;KG
2559;29214211;Acido sulfanilico e seus sais;1;KG
2560;29214219;Outros acidos aminobenzenossulfonicos e seus sais;1;KG
2561;29214221;3, 4-dicloroanilina e seus sais;1;KG
2562;29214229;Outras cloroanilinas e seus sais;1;KG
2563;29214231;4-nitroanilina;1;KG
2564;29214239;Outras nitroanilinas e seus sais;1;KG
2565;29214241;5-cloro-2-nitroanilina;1;KG
2566;29214249;Outras cloronitroanilinas e seus sais;1;KG
2567;29214290;Outros derivados da anilina e seus sais;1;KG
2568;29214311;O-toluidina;1;KG
2569;29214319;Outras toluidinas e seus sais;1;KG
2570;29214321;3-Nitro-4-toluidina e seus sais;1;KG
2571;29214322;Trifluralina;1;KG
2572;29214323;4-Cloro-2-toluidina;1;KG
2573;29214329;Outros derivados das toluidinas e seus sais;1;KG
2574;29214410;Difenilamina e seus sais;1;KG
2575;29214421;n-Octildifenilamina;1;KG
2576;29214422;n-Nonildifenilamina;1;KG
2577;29214429;Outros derivados da difenilamina e seus sais;1;KG
2578;29214500;1-Naftilamina (alfa-naftilamina), 2-naftilamina (beta-naftilamina), e seus derivados, sais destes produtos;1;KG
2579;29214610;Anfetamina e seus sais;1;KG
2580;29214620;Benzofetamina e seus sais;1;KG
2581;29214630;Dexanfetamina e seus sais;1;KG
2582;29214640;Etilanfetamina e seus sais;1;KG
2583;29214650;Fencanfamina e seus sais;1;KG
2584;29214660;Fentermina e seus sais;1;KG
2585;29214670;Lefetamina e seus sais;1;KG
2586;29214680;Levanfetamina e seus sais;1;KG
2587;29214690;Mefenorex e seus sais;1;KG
2588;29214910;Cloridrato de fenfluramina;1;KG
2589;29214921;2, 4-xilidina e seus sais;1;KG
2590;29214922;Pendimetalina;1;KG
2591;29214929;Outras xilidinas, seus derivados e seus sais;1;KG
2592;29214931;Sulfato de tranilcipromina;1;KG
2593;29214939;Outras tranilciprominas e seus sais;1;KG
2594;29214990;Outras monoaminas aromaticas, seus derivados e seus sais;1;KG
2595;29215111;M-Fenilenodiamina e seus sais;1;KG
2596;29215112;Diaminotoluenos (toluilenodiaminas);1;KG
2597;29215119;O-fenilenodiamina, p-fenilenodiamina e seus sais;1;KG
2598;29215120;Derivados sulfonados das fenilenodiaminas e de seus derivados, sais destes produtos;1;KG
2599;29215131;N,N-Di-sec-butil-p-fenilenodiamina;1;KG
2600;29215132;N-Isopropil-N-fenil-p-fenilenodiamina;1;KG
2601;29215133;N-(1,3-Dimetilbutil)-N-fenil-p-fenilenodiamina;1;KG
2602;29215134;N-(1,4-Dimetilpentil)-N-fenil-p-fenilenodiamina;1;KG
2603;29215135;N-Fenil-p-fenilenodiamina (4-aminodifenilamina) e seus sais;1;KG
2604;29215139;Outros derivados das fenilenodiaminas e seus sais;1;KG
2605;29215190;Outros derivados de diaminotulenos e seus sais;1;KG
2606;29215911;3, 3-diclorobenzidina;1;KG
2607;29215919;Benzidina, seus outros derivados e sais;1;KG
2608;29215921;4,4-Diaminodifenilmetano;1;KG
2609;29215929;Outros diaminodifenilmetanos;1;KG
2610;29215931;4,4-Diaminodifenilamina e seus sais;1;KG
2611;29215932;Acido 4,4-diaminodifenilamino-2-sulfonico e seus sais;1;KG
2612;29215939;Outras diaminodifenilaminas, seus derivados e seus sais;1;KG
2613;29215990;Outras poliaminas aromaticas, seus derivados e seus sais;1;KG
2614;29221100;Monoetanolamina e seus sais;1;KG
2615;29221200;Dietanolamina e seus sais;1;KG
2616;29221400;Dextropropoxifeno (DCI) e seus sais;1;KG
2617;29221500;Trietanolamina;1;KG
2618;29221600;Perfluoroctanossulfonato de dietanolamonio;1;KG
2619;29221700;Metildietanolamina e etildietanolamina;1;KG
2620;29221800;2-(N,N-diisopropilamino)etanol;1;KG
2621;29221911;Monoisopropanolamina;1;KG
2622;29221912;2,4-Diclorofenoxiacetato de triisopropanolamina;1;KG
2623;29221913;2,4-Diclorofenoxiacetato de dimetilpropanolamina;1;KG
2624;29221919;Propanolaminas, seus outros sais e derivados;1;KG
2625;29221921;Citrato de orfenadrina;1;KG
2626;29221929;Orfenadrina e seus outros sais;1;KG
2627;29221931;Cloridrato de ambroxol;1;KG
2628;29221939;Ambroxol e seus outros sais;1;KG
2629;29221941;Cloridrato de clobutinol;1;KG
2630;29221949;Clobutinol e seus outros sais;1;KG
2631;29221951;N, n-dimetil-2-aminoetanol e seus sais protonados;1;KG
2632;29221952;N,N-Dietil-2-aminoetanol e seus sais protonados;1;KG
2633;29221959;Outros n, n-dialquil-2-aminoetanol, seus sais protonados;1;KG
2634;29221971;Cloridrato;1;KG
2635;29221979;Outras propafenonas e seus sais;1;KG
2636;29221981;Tartarato;1;KG
2637;29221989;Outros aminoalcoois, exceto os que contenham mais de um tipo de funcao oxigenada, seus eteres e seus esteres, sais destes produtos;1;KG
2638;29221991;1-p-Nitrofenil-2-amino-1,3-propanodiol;1;KG
2639;29221992;Fumaratos de benciclano;1;KG
2640;29221993;Clembuterol (clenbuterol) e seu cloridrato;1;KG
2641;29221994;Mirtecaina;1;KG
2642;29221995;Tamoxifen e seu citrato;1;KG
2643;29221996;Propranolol e seus sais;1;KG
2644;29221999;Outros aminoalcoois, seus eteres, esteres e sais;1;KG
2645;29222100;Acidos aminonaftolsulfonicos e seus sais;1;KG
2646;29222911;P-aminofenol;1;KG
2647;29222919;O-aminofenois, m-aminofenois e seus sais;1;KG
2648;29222920;Nitroanisidinas e seus sais;1;KG
2649;29222990;Outros aminonaftois, aminofenois, seus eteres, esteres, sais;1;KG
2650;29223111;Anfepramona;1;KG
2651;29223112;Sais de anfepramona;1;KG
2652;29223120;Metadona e seus sais;1;KG
2653;29223130;Normetadona e seus sais;1;KG
2654;29223910;Aminoantraquinonas e seus sais;1;KG
2655;29223921;Cloridrato de ketamina;1;KG
2656;29223929;Ketamina e outros sais de ketamina;1;KG
2657;29223990;Outros aminoaldeidos, aminocetonas, etc.;1;KG
2658;29224110;Lisina;1;KG
2659;29224190;Esteres e sais, da lisina;1;KG
2660;29224210;Acido glutamico;1;KG
2661;29224220;Sais do acido glutamico;1;KG
2662;29224300;Acido antranilico e seus sais;1;KG
2663;29224410;Tilidina;1;KG
2664;29224420;Sais de tilidina;1;KG
2665;29224910;Glicina e seus sais;1;KG
2666;29224920;Acido etilenodiaminotetracetico (EDTA) e seus sais;1;KG
2667;29224931;Acido iminodiacetico;1;KG
2668;29224932;Sais do acido iminodiacetico;1;KG
2669;29224940;Acido dietilenotriaminopentacetico e seus sais;1;KG
2670;29224951;Alfa-fenilglicina;1;KG
2671;29224952;Cloridrato do cloreto de d(-)alfa-aminobenzenoacetila;1;KG
2672;29224959;Outros sais e derivados de alfa-fenilglicina;1;KG
2673;29224961;Diclofenaco de sodio;1;KG
2674;29224962;Diclofenaco de potassio;1;KG
2675;29224963;Diclofenaco de dietilamonio;1;KG
2676;29224964;Diclofenaco;1;KG
2677;29224969;Outros diclofenacos, seus sais e derivados;1;KG
2678;29224990;Outros aminoacidos, seus esteres e sais;1;KG
2679;29225011;Cloridrato de fenilefrina;1;KG
2680;29225019;Fenilefrina e seus outros sais;1;KG
2681;29225031;Levodopa;1;KG
2682;29225032;Metildopa;1;KG
2683;29225039;Outros derivados e sais da tirosina;1;KG
2684;29225091;N-(1-(Metoxicarbonil)propen-2-il)-alfa-amino-p-hidroxifenilacetato de sodio (NAPOH);1;KG
2685;29225099;Outros aminoalcooisfenois, aminoacidosfenois, etc, funcao oxigenada;1;KG
2686;29231000;Colina e seus sais;1;KG
2687;29232000;Lecitinas e outros fosfoaminolipidios;1;KG
2688;29233000;Perfluoroctanossulfonato de tetraetilamonio;1;KG
2689;29234000;Perfluoroctanossulfonato de didecildimetilamonio;1;KG
2690;29239010;Betaina e seus sais;1;KG
2691;29239020;Derivados da colina;1;KG
2692;29239030;Cloreto de 3-cloro-2-hidroxipropiltrimetilamonio;1;KG
2693;29239040;Halogenetos de alquil-trimetilamonio, com grupo alquila de C6 a C22;1;KG
2694;29239050;Halogenetos de dialquil-dimetilamonio ou de alquil-benzil-dimetilamonio, com grupo alquila de C6 a C22;1;KG
2695;29239060;Halogenetos de pentametil-alquil-propilenodiamonio, com grupo alquila de C6 a C22;1;KG
2696;29239090;Outros sais e hidroxidos de amonio quaternarios;1;KG
2697;29241100;Meprobamato (DCI);1;KG
2698;29241210;Fluoroacetamida;1;KG
2699;29241220;Fosfamidona;1;KG
2700;29241230;Monocrotofos;1;KG
2701;29241911;2-Cloro-N-metilacetoacetamida;1;KG
2702;29241919;Acetoacetamida, outros derivados/sais do produto;1;KG
2703;29241921;N-metilformamida;1;KG
2704;29241922;N,N-Dimetilformamida;1;KG
2705;29241929;Outras formamidas e acetamidas;1;KG
2706;29241931;Acrilamida;1;KG
2707;29241932;Metacrilamidas;1;KG
2708;29241939;Outros derivados da acrilamida;1;KG
2709;29241942;Dicrotofos;1;KG
2710;29241949;Crotonamidas e outros derivados deste produto;1;KG
2711;29241991;N,N-Dimetilureia;1;KG
2712;29241992;Carisoprodol;1;KG
2713;29241993;N,N-(Diestearoil)etilenodiamina (N,N-etilen-bis-estearamida);1;KG
2714;29241994;Dietanolamidas de acidos graxos de c12 a c18;1;KG
2715;29241999;Outras amidas aciclicas, derivados e sais deste produto;1;KG
2716;29242111;Hexanitrocarbanilidas;1;KG
2717;29242119;Carbanilidas, seus outros derivados e sais;1;KG
2718;29242120;Diuron;1;KG
2719;29242190;Outras ureinas, seus derivados e sais;1;KG
2720;29242300;Acido 2-acetamidobenzoico (acido N-acetilantranilico) e seus sais;1;KG
2721;29242400;Etinamato (DCI);1;KG
2722;29242500;Alaclor (ISO);1;KG
2723;29242911;Acetanilida;1;KG
2724;29242912;4-aminoacetanilida;1;KG
2725;29242913;Acetaminofen (paracetamol);1;KG
2726;29242914;Lidocaina e seu cloridrato;1;KG
2727;29242915;2,5-Dimetoxiacetanilida;1;KG
2728;29242919;Outros derivados da acetanilida e seus sais;1;KG
2729;29242920;Anilidas dos acidos hidroxinaftoicos, seus derivados e sais;1;KG
2730;29242931;Carbaril;1;KG
2731;29242932;Propoxur;1;KG
2732;29242939;Outros carbamatos;1;KG
2733;29242941;Teclozam;1;KG
2734;29242943;Atenolol, metolaclor;1;KG
2735;29242944;Acido ioxaglico;1;KG
2736;29242945;Iodamida;1;KG
2737;29242946;Cloreto do acido p-acetamidobenzenossulfonico;1;KG
2738;29242947;Acido ioxitalamico;1;KG
2739;29242949;Outras acetamidas e seus derivados;1;KG
2740;29242951;Bromoprida;1;KG
2741;29242952;Metoclopramida e seu cloridrato;1;KG
2742;29242959;Outras metoxibenzamidas, seus derivados e sais;1;KG
2743;29242961;Propanil;1;KG
2744;29242962;Flutamida;1;KG
2745;29242963;Prilocaina e seu cloridrato;1;KG
2746;29242964;Iobitridol;1;KG
2747;29242969;Outras propanamidas, seus derivados e sais;1;KG
2748;29242991;Aspartame;1;KG
2749;29242992;Diflubenzuron;1;KG
2750;29242993;Metalaxil;1;KG
2751;29242994;Triflumuron;1;KG
2752;29242995;Buclosamida;1;KG
2753;29242996;Benzoato de denatonio;1;KG
2754;29242999;Outras amidas ciclicas, seus derivados e sais;1;KG
2755;29251100;Sacarina e seus sais;1;KG
2756;29251200;Glutetimida (DCI);1;KG
2757;29251910;Talidomida;1;KG
2758;29251990;Outras imidas, seus derivados e sais;1;KG
2759;29252100;Clordimeforme;1;KG
2760;29252911;Aspartato de L-arginina;1;KG
2761;29252919;Outras argininas e sais;1;KG
2762;29252921;Guanidina;1;KG
2763;29252922;N,N-Difenilguanidina;1;KG
2764;29252923;Clorexidina e seus sais;1;KG
2765;29252929;Outros sais e derivados da guanidina;1;KG
2766;29252930;Amitraz;1;KG
2767;29252940;Isetionato de pentamidina;1;KG
2768;29252950;N-(3,7-Dimetil-7-hidroxioctilideno)antranilato de metila;1;KG
2769;29252990;Outros iminas, seus derivados e sais;1;KG
2770;29261000;Acrilonitrila;1;KG
2771;29262000;1-Cianoguanidina (diciandiamida);1;KG
2772;29263011;Fenproporex;1;KG
2773;29263012;Sais do fenproporex;1;KG
2774;29263020;Intermediario da metadona;1;KG
2775;29264000;alfa-Fenilacetoacetonitrila;1;KG
2776;29269011;Verapamil;1;KG
2777;29269012;Cloridrato de verapamil;1;KG
2778;29269019;Outros sais de verapamil;1;KG
2779;29269021;Alcool alfa-ciano-3-fenoxibenzilico;1;KG
2780;29269022;Ciflutrin;1;KG
2781;29269023;Cipermetrina;1;KG
2782;29269024;Deltametrina;1;KG
2783;29269025;Fenvalerato;1;KG
2784;29269026;Cialotrin (cyhalothrin);1;KG
2785;29269029;Outros derivados esteres do alcool alfa-ciano-3-fenoxibenzil;1;KG
2786;29269030;Sais de intermediario da metadona (DCI);1;KG
2787;29269091;Adiponitrila (1,4-dicianobutano);1;KG
2788;29269092;Cianidrina de acetona (acetona cianidrina);1;KG
2789;29269093;Closantel;1;KG
2790;29269095;Clorotalonil;1;KG
2791;29269096;Cianoacrilatos de etila;1;KG
2792;29269099;Outros compostos de funcao nitrila;1;KG
2793;29270010;Compostos diazoicos;1;KG
2794;29270021;Azodicarbonamida;1;KG
2795;29270029;Outros compostos azoicos;1;KG
2796;29270030;Compostos azoxicos;1;KG
2797;29280011;Metiletilacetoxima;1;KG
2798;29280019;Outras acetoximas, seus derivados e seus sais;1;KG
2799;29280020;Carbidopa;1;KG
2800;29280030;2-hidrazinoetanol;1;KG
2801;29280041;Fenilidrazina;1;KG
2802;29280042;Derivados da fenilidrazina;1;KG
2803;29280090;Outros derivados organicos da hidrazina e hidroxilamina;1;KG
2804;29291010;Diisocianato de difenilmetano;1;KG
2805;29291021;Mistura de isomeros de diisocianatos de tolueno;1;KG
2806;29291029;Outros diisocianatos de tolueno;1;KG
2807;29291030;Isocianato de 3,4-diclorofenila;1;KG
2808;29291090;Outros isocianatos;1;KG
2809;29299011;Acido ciclamico de sodio e seus sais;1;KG
2810;29299012;Acido ciclamico de calcio e seus sais;1;KG
2811;29299019;Outros acidos ciclamicos e seus sais;1;KG
2812;29299021;Dialogenetos de N,N-dialquilfosforoamidatos, com grupos alquila de C1 a C3;1;KG
2813;29299022;N,N-Dialquilfosforoamidatos de dialquila, com grupos alquila de C1 a C3;1;KG
2814;29299029;Outros N,N-Dialquilfosforoamidatos e seus derivados;1;KG
2815;29299090;Outros compostos de funcoes nitrogenadas;1;KG
2816;29302011;Eptc (tiocarbamato);1;KG
2817;29302012;Cartap;1;KG
2818;29302013;Tiobencarb (dietiltiocarbamato de S-4-clorobenzila);1;KG
2819;29302019;Outros tiocarbamatos;1;KG
2820;29302021;Ziram, dimetilditiocarbamato de sodio;1;KG
2821;29302022;Dietilditiocarbamato de zinco;1;KG
2822;29302023;Dibutilditiocarbamato de zinco;1;KG
2823;29302024;Metam sodio;1;KG
2824;29302029;Outros ditiocarbamatos;1;KG
2825;29303011;Monossulfetos de tetrametiltiourama;1;KG
2826;29303012;Sulfiram;1;KG
2827;29303019;Outros monossulfetos de tiourama;1;KG
2828;29303021;Thiram;1;KG
2829;29303022;Dissulfiram;1;KG
2830;29303029;Outros dissulfetos de tiourama;1;KG
2831;29303090;Tetrassulfetos de tiourama;1;KG
2832;29304010;DL-Metionina, com teor de cinzas sulfatadas superior a 0,1 %, em peso;1;KG
2833;29304090;Outras metioninas;1;KG
2834;29306000;2-(N,N-Dietilamino)etanotiol;1;KG
2835;29307000;Sulfeto de bis(2-hidroxietila) (tiodiglicol (DCI));1;KG
2836;29308010;Aldicarb;1;KG
2837;29308020;Captafol;1;KG
2838;29308030;Metamidofos;1;KG
2839;29309011;Acido tioglicolico e seus sais;1;KG
2840;29309012;Cisteina;1;KG
2841;29309013;N,N-Dialquil-2-aminoetanotiol, com grupos alquila de C1 a C3, e seus sais protonados;1;KG
2842;29309019;Outros tiois, seus derivados e sais;1;KG
2843;29309021;Tioureia;1;KG
2844;29309022;Tiofanato-Metila;1;KG
2845;29309023;4-Metil-3-tiosemicarbazida;1;KG
2846;29309029;Outras tioamidas, seus derivados e sais;1;KG
2847;29309031;2-(Etiltio)etanol, com uma concentracao superior ou igual a 98 %, em peso;1;KG
2848;29309032;3-(Metiltio)propanal, aldicarb;1;KG
2849;29309033;Clorotioformiato de S-etila;1;KG
2850;29309034;Acido 2-hidroxi-4-(metiltio)butanoico e seu sal calcico;1;KG
2851;29309035;Metomil;1;KG
2852;29309036;Carbocisteina;1;KG
2853;29309037;4-Sulfatoetilsulfonil-2,5-dimetoxianilina, 4-sulfatoetilsulfonil-2-metoxi-5-metilanilina, 4-sulfatoetilsulfonil-2-metoxianilina;1;KG
2854;29309039;Outros tioeteres, tioesteres, seus derivados e sais;1;KG
2855;29309041;Fosforotioato de O,O-dietila e de S-[2-(dietilamino)etila] e seus sais alquilados ou protonados;1;KG
2856;29309042;Fosforotioato de o, o-dimetila e de s-[2-(1-m;1;KG
2857;29309043;Fosforotioato de O-(4-bromo-2-clorofenila) O-etila e de S-propila (profenofos);1;KG
2858;29309049;Outros fosforotioatos e seus derivados, e sais destes produtos;1;KG
2859;29309051;Forato;1;KG
2860;29309052;Dissulfoton;1;KG
2861;29309053;Etion;1;KG
2862;29309054;Dimetoato;1;KG
2863;29309057;Fosforoditioato de O,O-dimetila e de S-[2-(etiltio)etila] (tiometon);1;KG
2864;29309059;Outros fosforoditioatos, seus derivados e sais;1;KG
2865;29309061;Acefato;1;KG
2866;29309069;Outros fosforoamidotioatos, seus derivados e sais;1;KG
2867;29309071;Tiaprida;1;KG
2868;29309072;Bicalutamida;1;KG
2869;29309079;Outras sulfonas;1;KG
2870;29309081;Sulfeto de 2-cloroetila e de clorometila;1;KG
2871;29309082;Sulfeto de bis (2-cloroetila);1;KG
2872;29309083;Bis (2-cloroetiltio) metano;1;KG
2873;29309084;1, 2-bis (2-cloroetiltio) etano;1;KG
2874;29309085;1,3-Bis(2-cloroetiltio)-n-propano;1;KG
2875;29309086;1,4-Bis(2-cloroetiltio)-n-butano;1;KG
2876;29309087;1,5-Bis(2-cloroetiltio)-n-pentano;1;KG
2877;29309088;Oxido de bis(2-cloroetiltiometila);1;KG
2878;29309089;Oxido de bis(2-cloroetiltioetila);1;KG
2879;29309091;Captan;1;KG
2880;29309093;Metileno-bis-tiocianato;1;KG
2881;29309094;Dimetiltiofosforamida;1;KG
2882;29309095;Etilditiofosfonato de O-etila e de S-fenila (fonofos);1;KG
2883;29309096;Hidrogenio alquil(de C1 a C3)fosfonotioatos de [S-2-(dialquil(de C1 a C3)amino)etila], seus esteres de O-alquila (de ate C10, incluindo os cicloalquila), sais alquilados ou protonados destes produtos;1;KG
2884;29309097;Outros compostos que contenham um atomo de fosforo ligado a um grupo alquila (de C1 a C3), sem outros atomos de carbono;1;KG
2885;29309098;Ditiocarbonatos (xantatos e xantogenatos);1;KG
2886;29309099;Outros tiocompostos organicos;1;KG
2887;29311000;Chumbo tetrametila e chumbo tetraetileno;1;KG
2888;29312000;Compostos de tributilestanho;1;KG
2889;29313100;Metilfosfonato de dimetila;1;KG
2890;29313200;Propilfosfonato de dimetila;1;KG
2891;29313300;Etilfosfonato de dietila;1;KG
2892;29313400;Metilfosfonato de sodio 3-(triidroxisilil)propila;1;KG
2893;29313500;2,4,6-trioxido de 2,4,6-tripropil-1,3,5,2,4,6-trioxatrifosfinano;1;KG
2894;29313600;Metilfosfonato de (5-etil-2-metil-2-oxido-1,3,2-dioxafosfinan-5-il)metil metila;1;KG
2895;29313700;Metilfosfonato de bis[(5-etil-2-metil-2-oxido-1,3,2-dioxafosfinan-5-il)metila];1;KG
2896;29313800;Sal do acido metilfosfonico e de (aminoiminometil)ureia (1:1);1;KG
2897;29313911;Etefon, difenilfosfonato(4,4-bis((dimetoxifosfinil)metil)difenila);1;KG
2898;29313912;Glifosato e seu sal de monoisopropilamina;1;KG
2899;29313913;Etidronato dissodico;1;KG
2900;29313914;Triclorfon;1;KG
2901;29313915;Glufosinato de amonio;1;KG
2902;29313916;Hidrogenofosfonato de bis(2-etilexilo);1;KG
2903;29313917;Acido fosfonometiliminodiacetico, acido trimetilfosfonico;1;KG
2904;29313918;Acido clodronico e seu sal dissodico, fotemustina;1;KG
2905;29313991;Alquil(de C1 a C3)fosfonofluoridatos de O-alquila (de ate C10, incluindo os cicloalquila);1;KG
2906;29313992;Metilfosfonocloridato de O-isopropila;1;KG
2907;29313993;Metilfosfonocloridato de O-pinacolila;1;KG
2908;29313994;Difluoreto de alquilfosfonila, com grupo alquila de C1 a C3;1;KG
2909;29313995;Hidrogenio alquil(de C1 a C3)fosfonitos de [O-2-(dialquil(de C1 a C3)amino)etila], seus esteres de O-alquila (de ate C10, incluindo os cicloalquila), sais alquilados ou protonados destes produtos;1;KG
2910;29313996;Outros compostos que contenham um atomo de fosforo ligado a um grupo alquila (de C1 a C3), sem outros atomos de carbono;1;KG
2911;29313997;N,N-Dialquil(de C1 a C3)fosforoamidocianidatos de O-alquila (de ate C10, incluindo os cicloalquila);1;KG
2912;29313999;Outros derivados organofosforados;1;KG
2913;29319021;Bis(trimetilsilil)ureia;1;KG
2914;29319029;Outros compostos organossilicicos;1;KG
2915;29319041;Acetato de trifenilestanho;1;KG
2916;29319042;Tetraoctilestanho;1;KG
2917;29319043;Ciexatin;1;KG
2918;29319044;Hidroxido de trifenilestanho;1;KG
2919;29319045;Oxido de fembutatin (oxido de fenbutatin);1;KG
2920;29319046;Sais de dimetil-estanho, de dibutil-estanho e de dioctil-estanho, dos acidos carboxilicos ou tioglicolicos e de seus esteres;1;KG
2921;29319049;Outros compostos organometalicos do estanho;1;KG
2922;29319051;Acido metilarsinico e seus sais;1;KG
2923;29319052;2-clorovinil-dicloroarsina;1;KG
2924;29319053;Bis(2-clorovinil)cloroarsina;1;KG
2925;29319054;Tris(2-clorovinil)arsina;1;KG
2926;29319059;Outros compostos organo-arseniais;1;KG
2927;29319061;Tricloreto de etilaluminio (sesquicloreto de etilaluminio);1;KG
2928;29319062;Cloreto de dietialuminio;1;KG
2929;29319069;Outros compostos organo-aluminicos;1;KG
2930;29319090;Outros compostos organo-inorganicos;1;KG
2931;29321100;Tetraidrofurano;1;KG
2932;29321200;2-Furaldeido (furfural);1;KG
2933;29321310;Alcool furfurilico;1;KG
2934;29321320;Alcool tetraidrofurfurilico;1;KG
2935;29321400;Sucralose;1;KG
2936;29321910;Ranitidina e seus sais;1;KG
2937;29321920;Nafronil;1;KG
2938;29321930;Nitrovin;1;KG
2939;29321940;Bioresmetrina;1;KG
2940;29321950;Diacetato de 5-nitrofurfurilideno (NFDA);1;KG
2941;29321990;Outros compostos heterociclicos com 1 ciclo furano, nao condensado;1;KG
2942;29322000;Lactonas;1;KG
2943;29329100;Isossafrol;1;KG
2944;29329200;1-(1,3-Benzodioxol-5-il)propan-2-ona;1;KG
2945;29329300;Piperonal;1;KG
2946;29329400;Safrol;1;KG
2947;29329500;Tetraidrocanabinois (todos os isomeros);1;KG
2948;29329911;Eucaliptol;1;KG
2949;29329912;Quercetina;1;KG
2950;29329913;Dinitrato de isossorbida;1;KG
2951;29329914;Carbofurano;1;KG
2952;29329991;Cloridrato de amiodarona;1;KG
2953;29329992;1,3,4,6,7,8-Hexaidro-4,6,6,7,8,8-hexametilciclopenta-gama-2-benzopirano;1;KG
2954;29329993;Dibenzilideno-sorbitol;1;KG
2955;29329994;Carbosulfan ((dibutilaminotio)metilcarbamato de 2,3-diidro-2,2-dimetilbenzofuran-7-ila);1;KG
2956;29329999;Outros compostos heterociclicos de heteroatomos de oxigenio;1;KG
2957;29331111;Dipirona;1;KG
2958;29331112;Magnopirol (dipirona magnesica);1;KG
2959;29331119;Outros acidos 1-fenil-2, 3-dimetil-5-pirazolona-4-...;1;KG
2960;29331120;Metileno-bis(4-metilamino-1-fenil-2,3-dimetil)pirazolona;1;KG
2961;29331190;Outras fenazonas (antipirinas) e seus derivados;1;KG
2962;29331911;Fenilbutazona calcica;1;KG
2963;29331919;Outras fenilbutazonas e seus sais;1;KG
2964;29331990;Outros compostos heterociclicos contendo 1 ciclo pirazol, nao condensado;1;KG
2965;29332110;Iprodiona;1;KG
2966;29332121;Fenitoina e seu sal sodico;1;KG
2967;29332129;Outros sais da fenitoina;1;KG
2968;29332190;Outras hidantoinas e seus derivados;1;KG
2969;29332911;2-metil-5-nitroimidazol;1;KG
2970;29332912;Metronidazol e seus sais;1;KG
2971;29332913;Tinidazol;1;KG
2972;29332919;Outros compostos heterociclicos com 1 ciclo nitroimidazol;1;KG
2973;29332921;Econazol e seu nitrato;1;KG
2974;29332922;Nitrato de miconazol;1;KG
2975;29332923;Cloridrato de clonidina;1;KG
2976;29332924;Nitrato de isoconazol;1;KG
2977;29332925;Clotrimazol;1;KG
2978;29332929;Outros compostos heterociclicos com ciclo benzeno clorado;1;KG
2979;29332930;Cimetidina e seus sais;1;KG
2980;29332940;4-Metil-5-hidroximetilimidazol e seus sais;1;KG
2981;29332991;Imidazol;1;KG
2982;29332992;Histidina e seus sais;1;KG
2983;29332993;Ondansetron e seus sais;1;KG
2984;29332994;1-Hidroxietil-2-undecanoilimidazolina;1;KG
2985;29332995;1-Hidroxietil-2-(8-heptadecenoil)imidazolina;1;KG
2986;29332999;Outros compostos heterociclicos com 1 ciclo de imizadol nao condensado;1;KG
2987;29333110;Piridina;1;KG
2988;29333120;Sais de piridina;1;KG
2989;29333200;Piperidina e seus sais;1;KG
2990;29333311;Alfentanil;1;KG
2991;29333312;Anileridina;1;KG
2992;29333319;Sais de alfentanil ou de anileridina;1;KG
2993;29333321;Bezitramida;1;KG
2994;29333322;Bromazepam;1;KG
2995;29333329;Sais de bezitramida ou de bromazepam;1;KG
2996;29333330;Cetobemidona e seus sais;1;KG
2997;29333341;Difenoxilato;1;KG
2998;29333342;Cloridrato de difenoxilato;1;KG
2999;29333349;Outros sais de difenoxilato;1;KG
3000;29333351;Difenoxina;1;KG
3001;29333352;Dipipanona;1;KG
3002;29333359;Sais de difenoxina ou de dipipanona;1;KG
3003;29333361;Fenciclidina (PCP);1;KG
3004;29333362;Fenoperidina;1;KG
3005;29333363;Fentanil;1;KG
3006;29333369;Sais de fenciclidina, fenoperidina ou fentanil;1;KG
3007;29333371;Metilfenidato;1;KG
3008;29333372;Pentazocina;1;KG
3009;29333379;Sais de metilfenidato ou de pentazocina;1;KG
3010;29333381;Petidina;1;KG
3011;29333382;Intermediario A da petidina;1;KG
3012;29333383;Pipradrol;1;KG
3013;29333384;Cloridrato de petidina;1;KG
3014;29333389;Outros sais de petidina ou do intermediario A;1;KG
3015;29333391;Piritramida;1;KG
3016;29333392;Propiram;1;KG
3017;29333393;Trimeperidina;1;KG
3018;29333399;Sais de piritramida, propiram ou trimeperidina;1;KG
3019;29333912;Droperidol;1;KG
3020;29333913;Acido niflumico;1;KG
3021;29333914;Haloxifop (acido (RS)-2-(4-(3-cloro-5-trifluorometil-2-piridiloxi)fenoxi)propionico);1;KG
3022;29333915;Haloperidol;1;KG
3023;29333919;Outros compostos heterociclicos com fluor e/ou bromo, ligacao covalente;1;KG
3024;29333921;Picloram;1;KG
3025;29333922;Clorpirifos;1;KG
3026;29333923;Malato acido de cleboprida (malato de cleboprida);1;KG
3027;29333924;Cloridrato de cloperamida;1;KG
3028;29333925;Acido 2-(2metil-3cloroanilino) nicotinico/sal de lisina;1;KG
3029;29333929;Outros compostos heterociclicos com cloro, sem fluor nem bromo;1;KG
3030;29333931;Terfenadina;1;KG
3031;29333932;Biperideno e seus sais;1;KG
3032;29333933;Acido isonicotinico;1;KG
3033;29333934;5-Etil-2,3-dicarboxipiridina (5-EPDC);1;KG
3034;29333935;Imazetapir (acido (RS)-5-etil-2-(4-isopropil-4-metil-5-oxo-2-imidazolin-2-il)nicotinico);1;KG
3035;29333936;Quinuclidin-3-ol;1;KG
3036;29333939;Fenoperidina e seus sais;1;KG
3037;29333943;Nifedipina;1;KG
3038;29333944;Nitrendipina;1;KG
3039;29333945;Maleato de pirilamina;1;KG
3040;29333946;Omeprazol;1;KG
3041;29333947;Benzilato de 3-quinuclidinila;1;KG
3042;29333948;Nimodipina;1;KG
3043;29333949;Outros compostos contendo ciclo piridina nao condensado;1;KG
3044;29333981;Cloridrato de benzetimida;1;KG
3045;29333982;Cloridrato de mepivacaina;1;KG
3046;29333983;Cloridrato de bupivacaina;1;KG
3047;29333984;Dicloreto de paraquat;1;KG
3048;29333989;Outros compostos heterociclicos contendo piridina, n- rad.alquila, etc;1;KG
3049;29333991;Cloridrato de fenazopiridina;1;KG
3050;29333992;Isoniazida;1;KG
3051;29333993;3-Cianopiridina;1;KG
3052;29333994;4,4-Bipiridina;1;KG
3053;29333999;Outros compostos heterociclicos 1 ciclo piridina nao condensado;1;KG
3054;29334110;Levorfanol;1;KG
3055;29334120;Sais de levorfanol;1;KG
3056;29334911;Acido 2,3-quinolinodicarboxilico;1;KG
3057;29334912;Rosoxacina;1;KG
3058;29334913;Imazaquin;1;KG
3059;29334919;Outros derivados do acido quinolinocarboxilico;1;KG
3060;29334920;Oxaminiquina;1;KG
3061;29334930;Broxiquinolina;1;KG
3062;29334940;Esteres do levorfanol;1;KG
3063;29334990;Outros compostos contendo ciclos de quinoleina, etc.;1;KG
3064;29335200;Malonilureia (acido barbiturico) e seus sais;1;KG
3065;29335311;Alobarbital e seus sais;1;KG
3066;29335312;Amobarbital e seus sais;1;KG
3067;29335321;Barbital e seus sais;1;KG
3068;29335322;Butalbital e seus sais;1;KG
3069;29335323;Butobarbital e seus sais;1;KG
3070;29335330;Ciclobarbital e seus sais;1;KG
3071;29335340;Fenobarbital e seus sais;1;KG
3072;29335350;Metilfenobarbital e seus sais;1;KG
3073;29335360;Pentobarbital e seus sais;1;KG
3074;29335371;Secbutabarbital e seus sais;1;KG
3075;29335372;Secobarbital e seus sais;1;KG
3076;29335380;Venilbital e seus sais;1;KG
3077;29335400;Outros derivados da manolinureia (acido barbiturico);1;KG
3078;29335510;Loprazolam e seus sais;1;KG
3079;29335520;Mecloqualona e seus sais;1;KG
3080;29335530;Metaqualona e seus sais;1;KG
3081;29335540;Zipeprol e seus sais;1;KG
3082;29335911;Oxatomida;1;KG
3083;29335912;Praziquantel;1;KG
3084;29335913;Norfloxacina e seu nicotinato;1;KG
3085;29335914;Flunarizina e seu dicloridrato;1;KG
3086;29335915;Enrofloxacina, sais de piperazina;1;KG
3087;29335916;Cloridrato de buspirona;1;KG
3088;29335919;Outros compostos heterociclicos, com ciclo piperazina;1;KG
3089;29335921;Bromacil;1;KG
3090;29335922;Terbacil;1;KG
3091;29335923;Fluorouracil;1;KG
3092;29335929;Outros compostos heterociclicos ciclo pirimidina, halogenado ligacao covalente;1;KG
3093;29335931;Propiltiouracil;1;KG
3094;29335932;Diazinon;1;KG
3095;29335933;Pirazofos;1;KG
3096;29335934;Azatioprina;1;KG
3097;29335935;6-mercaptopurina;1;KG
3098;29335939;Outros compostos heterociclicos ciclo pirimidina, enxofre, sem halogenado;1;KG
3099;29335941;Trimetoprima;1;KG
3100;29335942;Aciclovir;1;KG
3101;29335943;Tosilatos de dipiridamol;1;KG
3102;29335944;Nicarbazina;1;KG
3103;29335945;Bissulfito de menadiona dimetilpirimidinol;1;KG
3104;29335949;Outros compostos heterociclicos ciclo pirimidina, funcao alcool e/ou eter;1;KG
3105;29335991;Minoxidil;1;KG
3106;29335992;2-aminopirimidina;1;KG
3107;29335999;Outros compostos heterociclicos com ciclo pirimidina/piperazina;1;KG
3108;29336100;Melamina;1;KG
3109;29336911;2,4,6-Triclorotriazina (cloreto cianurico);1;KG
3110;29336912;Mercaptodiclorotriazina;1;KG
3111;29336913;Atrazina;1;KG
3112;29336914;Simazina;1;KG
3113;29336915;Cianazina;1;KG
3114;29336916;Anilazina;1;KG
3115;29336919;Outros compostos heterociclicos com ciclo triazina, com cloro ligacao covalente;1;KG
3116;29336921;N,N,N-Triidroxietilexaidrotriazina;1;KG
3117;29336922;Hexazinona;1;KG
3118;29336923;Metribuzim;1;KG
3119;29336929;Outros compostos heterociclicos triazina, sem cloro ligacao covalente;1;KG
3120;29336991;Ametrina;1;KG
3121;29336992;Metenamina (hexametilenotetramina) e seus sais;1;KG
3122;29336999;Outros compostos heterociclicos 1 ciclo triazina nao condensado;1;KG
3123;29337100;6-Hexanolactama (epsilon-caprolactama);1;KG
3124;29337210;Clobazam;1;KG
3125;29337220;Metilprilona;1;KG
3126;29337910;Piracetam;1;KG
3127;29337990;Outras lactamas;1;KG
3128;29339111;Alprazolam;1;KG
3129;29339112;Camazepam;1;KG
3130;29339113;Clonazepam;1;KG
3131;29339114;Clorazepato;1;KG
3132;29339115;Clorodiazepoxido;1;KG
3133;29339119;Sais de alprazolam, camazepam, clonazepam, etc.;1;KG
3134;29339121;Delorazepam;1;KG
3135;29339122;Diazepam;1;KG
3136;29339123;Estazolam;1;KG
3137;29339129;Sais de delorazepam, diazepam ou estazolam;1;KG
3138;29339131;Fludiazepam;1;KG
3139;29339132;Flunitrazepam;1;KG
3140;29339133;Flurazepam;1;KG
3141;29339134;Halazepam;1;KG
3142;29339139;Sais de fludiazepam, flunitrazepam, etc.;1;KG
3143;29339141;Loflazepato de etila;1;KG
3144;29339142;Lorazepam;1;KG
3145;29339143;Lormetazepam;1;KG
3146;29339149;Sais de loflazepato de etila, lorazepam, etc.;1;KG
3147;29339151;Mazindol;1;KG
3148;29339152;Medazepam;1;KG
3149;29339153;Midazolam;1;KG
3150;29339159;Sais de mazindol, medazepam ou midazolam;1;KG
3151;29339161;Nimetazepam;1;KG
3152;29339162;Nitrazepam;1;KG
3153;29339163;Nordazepam;1;KG
3154;29339164;Oxazepam;1;KG
3155;29339169;Sais de nimetazepam, nitrazepam, nordazepam, oxazepam;1;KG
3156;29339171;Pinazepam;1;KG
3157;29339172;Pirovalerona;1;KG
3158;29339173;Prazepam;1;KG
3159;29339179;Sais de pinazepam, pirovalerona ou prazepam;1;KG
3160;29339181;Temazepam;1;KG
3161;29339182;Tetrazepam;1;KG
3162;29339183;Triazolam;1;KG
3163;29339189;Sais de temazepam, tetrazepam ou triazolam;1;KG
3164;29339200;Azinfos metil (ISO);1;KG
3165;29339911;Pirazinamida;1;KG
3166;29339912;Cloridrato de amilorida;1;KG
3167;29339913;Pindolol;1;KG
3168;29339919;Outros compostos heterociclicos contendo ciclo pirazina;1;KG
3169;29339920;Outros compostos heterociclicos contendo ciclo diazepina (hidrogenado);1;KG
3170;29339931;Dibenzoazepina (iminoestilbeno);1;KG
3171;29339932;Carbamazepina;1;KG
3172;29339933;Cloridrato de clomipramina;1;KG
3173;29339934;Molinate (hexaidroazepin-1-carbotioato de s-e;1;KG
3174;29339935;Hexametilenoimina;1;KG
3175;29339939;Outros compostos heterociclicos contendo ciclo azepina;1;KG
3176;29339941;Clemastina e seus derivados, sais destes produtos;1;KG
3177;29339942;Amisulprida;1;KG
3178;29339943;Sultoprida;1;KG
3179;29339944;Alizaprida;1;KG
3180;29339945;Buflomedil e seus derivados, sais destes produtos;1;KG
3181;29339946;Maleato de enalapril;1;KG
3182;29339947;Ketorolac trometamina;1;KG
3183;29339949;Outros compostos heterociclicos contendo ciclo pirrol;1;KG
3184;29339951;Benomil;1;KG
3185;29339952;Oxifendazol;1;KG
3186;29339953;Albendazol e seu sulfoxido;1;KG
3187;29339954;Mebendazol;1;KG
3188;29339955;Flubendazol;1;KG
3189;29339956;Fembendazol;1;KG
3190;29339959;Outros compostos heterociclicos contendo ciclo imidazol;1;KG
3191;29339961;Triadimenol;1;KG
3192;29339962;Triadimefon;1;KG
3193;29339963;Triazofos (fosforotioato de o, o-dietila o-(1;1;KG
3194;29339969;Outros compostos heterociclicos contendo ciclo triazol;1;KG
3195;29339991;Azinfos etilico;1;KG
3196;29339992;Acido nalidixico;1;KG
3197;29339993;Clofazimina;1;KG
3198;29339995;Metilssulfato de amezinio;1;KG
3199;29339996;Hidrazida maleica e seus sais;1;KG
3200;29339999;Outros compostos heterociclicos com heteroatomo de nitrogenio;1;KG
3201;29341010;Fentiazac;1;KG
3202;29341020;Cloridrato de tiazolidina;1;KG
3203;29341030;Tiabendazol;1;KG
3204;29341090;Outros compostos heterociclicos com um ciclo tiazol nao condensado;1;KG
3205;29342010;2-Mercaptobenzotiazol e seus sais;1;KG
3206;29342020;2,2-Ditio-bis(benzotiazol) (dissulfeto de benzotiazila);1;KG
3207;29342031;2-(Terbutilaminotio)benzotiazol (N-terbutil-benzotiazol-sulfenamida);1;KG
3208;29342032;2-(Cicloexilaminotio)benzotiazol (N-cicloexil-benzotiazol-sulfenamida);1;KG
3209;29342033;2-(Dicicloexilaminotio)benzotiazol (N,N-dicicloexil-benzotiazol-sulfenamida);1;KG
3210;29342034;2-(4-Morfoliniltio)benzotiazol (N-oxidietileno-benzotiazol-sulfenamida);1;KG
3211;29342039;Outros benzotiazois-sulfenamidas;1;KG
3212;29342040;2-(Tiocianometiltio)benzotiazol (TCMTB);1;KG
3213;29342090;Outros compostos heterociclicos com ciclos de benzotiazol;1;KG
3214;29343010;Maleato de metotrimeprazina (maleato de levomepromazina);1;KG
3215;29343020;Enantato de flufenazina;1;KG
3216;29343030;Prometazina;1;KG
3217;29343090;Outros compostos heterociclicos com estrutura de ciclo fenotiazina;1;KG
3218;29349111;Aminorex e seus sais;1;KG
3219;29349112;Brotizolan e seus sais;1;KG
3220;29349121;Clotiazepam;1;KG
3221;29349122;Cloxazolam;1;KG
3222;29349123;Dextromoramida;1;KG
3223;29349129;Sais de clotiazepam, cloxazolam, dextromoramida;1;KG
3224;29349131;Fendimetrazina e seus sais;1;KG
3225;29349132;Fenmetrazina e seus sais;1;KG
3226;29349133;Haloxazolam e seus sais;1;KG
3227;29349141;Ketazolam;1;KG
3228;29349142;Mesocarb;1;KG
3229;29349149;Sais do ketazolam e mesocarb;1;KG
3230;29349150;Oxazolam e seus sais;1;KG
3231;29349160;Pemolina e seus sais;1;KG
3232;29349170;Sufentanila e seus sais;1;KG
3233;29349911;Morfolina e seus sais;1;KG
3234;29349912;Pirenoxina sodica (catalino sodico);1;KG
3235;29349913;Nimorazol;1;KG
3236;29349914;Anidrido isatoico (2h-3, 1-benzoxazina-2, 4-(1h;1;KG
3237;29349915;4, 4-ditiodimorfolina;1;KG
3238;29349919;Outros compostos heterociclicos contendo ciclo oxazina;1;KG
3239;29349922;Zidovudina (AZT);1;KG
3240;29349923;Timidina;1;KG
3241;29349924;Furazolidona;1;KG
3242;29349925;Citarabina;1;KG
3243;29349926;Oxadiazona;1;KG
3244;29349927;Estavudina;1;KG
3245;29349929;Outros compostos heterociclicos com 3 heteroatomos nitrogenados;1;KG
3246;29349931;Cetoconazol;1;KG
3247;29349932;Cloridrato de prazosina;1;KG
3248;29349933;Talniflumato;1;KG
3249;29349934;Acidos nucleicos e seus sais;1;KG
3250;29349935;Propiconazol;1;KG
3251;29349939;Outros compostos heterociclicos com heteroatomo de nitrogenio;1;KG
3252;29349941;Tiofeno;1;KG
3253;29349942;Acido 6-aminopenicilanico;1;KG
3254;29349943;Acido 7-aminocefalosporanico;1;KG
3255;29349944;Acido 7-aminodesacetoxicefalosporanico;1;KG
3256;29349945;Clormezanona;1;KG
3257;29349946;9-(N-Metil-4-piperidinilideno)tioxanteno;1;KG
3258;29349949;Outros compostos heterociclicos com heteroatomo de enxofre;1;KG
3259;29349951;Tebutiuron;1;KG
3260;29349952;Tetramisol;1;KG
3261;29349953;Levamisol e seus sais;1;KG
3262;29349954;Tioconazol;1;KG
3263;29349959;Outros compostos heterociclicos com tres heteroatomos de enxofre;1;KG
3264;29349961;Cloridrato de tizanidina;1;KG
3265;29349969;Outros compostos heterociclicos com heteroatomo de enxofre;1;KG
3266;29349991;Timolol;1;KG
3267;29349992;Maleato acido de timolol;1;KG
3268;29349993;Lamivudina;1;KG
3269;29349999;Outros compostos heterociclicos;1;KG
3270;29351000;N-Metilperfluoroctano sulfonamida;1;KG
3271;29352000;N-Etilperfluoroctano sulfonamida;1;KG
3272;29353000;N-Etil-N-(2-hidroxietil)perfluoroctano sulfonamida;1;KG
3273;29354000;N-(2-Hidroxietil)-N-metilperfluoroctano sulfonamida;1;KG
3274;29355000;Outras perfluoroctanossulfonamidas;1;KG
3275;29359011;Sulfadiazina e seu sal sodico;1;KG
3276;29359012;Clortalidona;1;KG
3277;29359013;Sulpirida;1;KG
3278;29359014;Veraliprida;1;KG
3279;29359015;Sulfametazina (4,6-dimetil-2-sulfanilamidopirimidina) e seu sal sodico;1;KG
3280;29359019;Outras sulfonamidas cuja estrutura contem exclusivamente heterociclo(s) com heteroatomo(s) de nitrogenio (azoto);1;KG
3281;29359021;Furosemida;1;KG
3282;29359022;Ftalilsulfatiazol;1;KG
3283;29359023;Piroxicam;1;KG
3284;29359024;Tenoxicam;1;KG
3285;29359025;Sulfametoxazol;1;KG
3286;29359029;Outras sulfonamidas cuja estrutura contem outro(s) heterociclo(s);1;KG
3287;29359091;Cloramina-B e cloramina-T;1;KG
3288;29359092;Gliburida;1;KG
3289;29359093;Toluenossulfonamidas;1;KG
3290;29359094;Nimesulida;1;KG
3291;29359095;Bumetanida;1;KG
3292;29359096;Sulfaguanidina;1;KG
3293;29359097;Sulfluramida;1;KG
3294;29359099;Outras sulfonamidas;1;KG
3295;29362111;Vitamina A1 alcool (retinol);1;KG
3296;29362112;Acetato de vitamina A1 alcool;1;KG
3297;29362113;Palmitato de vitamina a1 alcool;1;KG
3298;29362119;Outros derivados da vitamina A1 alcool, nao misturados;1;KG
3299;29362190;Outras vitaminas A e seus derivados, nao misturados;1;KG
3300;29362210;Cloridrato de vitamina b1 (tiamina), nao misturado;1;KG
3301;29362220;Mononitrato de vitamina b1 (tiamina), nao misturado;1;KG
3302;29362290;Outras vitaminas b1 e seus derivados, nao misturados;1;KG
3303;29362310;Vitamina B2 (riboflavina);1;KG
3304;29362320;5-Fosfato sodico de vitamina B2 (5-fosfato sodico de riboflavina), nao misturado;1;KG
3305;29362390;Outros derivados da vitamina B2, nao misturados;1;KG
3306;29362410;D-Pantotenato de calcio, nao misturado;1;KG
3307;29362490;Outros acidos d- ou dl-pantotenico (vitamina B3/B5), derivados;1;KG
3308;29362510;Vitamina B6, nao misturada;1;KG
3309;29362520;Cloridrato de piridoxina, nao misturado;1;KG
3310;29362590;Outros derivados da vitamina B6, nao misturados;1;KG
3311;29362610;Vitamina B12 (cianocobalamina), nao misturada;1;KG
3312;29362620;Cobamamida nao misturada;1;KG
3313;29362630;Hidroxocobalamina e seus sais, nao misturados;1;KG
3314;29362690;Outros derivados da vitamina B12, nao misturados;1;KG
3315;29362710;Vitamina C (acido L- ou DL-ascorbico), nao misturada;1;KG
3316;29362720;Ascorbato de sodio, nao misturado;1;KG
3317;29362790;Outros derivados da vitamina c, nao misturados;1;KG
3318;29362811;D- ou DL-alfa-Tocoferol, nao misturados;1;KG
3319;29362812;Acetato de D- ou DL-alfa-tocoferol, nao misturados;1;KG
3320;29362819;Outros derivados de d- ou dl-alfa-tocoferol, nao misturados;1;KG
3321;29362890;Outras vitaminas e seus derivados, nao misturados;1;KG
3322;29362911;Vitamina B9 (acido folico) e seus sais, nao misturados;1;KG
3323;29362919;Outros derivados da vitamina b9, nao misturados;1;KG
3324;29362921;Vitamina D3 (colecalciferol), nao misturada;1;KG
3325;29362929;Outras vitaminas d e seus derivados, nao misturados;1;KG
3326;29362931;Vitamina h (biotina), nao misturada;1;KG
3327;29362939;Outros derivados da vitamina h, nao misturados;1;KG
3328;29362940;Vitaminas k e seus derivados, nao misturados;1;KG
3329;29362951;Acido nicotinico, nao misturado;1;KG
3330;29362952;Nicotinamida nao misturada;1;KG
3331;29362953;Nicotinato de sodio, nao misturado;1;KG
3332;29362959;Outros derivados do acido nicotinico, nao misturados;1;KG
3333;29362990;Outras vitaminas e seus derivados, nao misturados;1;KG
3334;29369000;Provitaminas e vitaminas, misturadas;1;KG
3335;29371100;Somatotropina, seus derivados e analogos estruturais;1;KG
3336;29371200;Insulina e seus sais;1;KG
3337;29371910;Acth (corticotropina);1;KG
3338;29371920;Hcg (gonadotropina corionica);1;KG
3339;29371930;Pmsg (gonadotropina serica);1;KG
3340;29371940;Menotropinas;1;KG
3341;29371950;Oxitocina;1;KG
3342;29371990;Outros hormonios polipeptideos, proteicos, etc.;1;KG
3343;29372110;Cortisona;1;KG
3344;29372120;Hidrocortisona;1;KG
3345;29372130;Prednisona (deidrocortisona);1;KG
3346;29372140;Prednisolona (deidroidrocortisona);1;KG
3347;29372210;Dexametasona e seus acetatos;1;KG
3348;29372221;Acetonida da triancinolona;1;KG
3349;29372229;Triancinolona e outros derivados;1;KG
3350;29372231;Valerato de diflucortolona;1;KG
3351;29372239;Fluorcortolona e outros derivados;1;KG
3352;29372290;Outros derivados halogenados dos hormonios corticossupra-renais;1;KG
3353;29372310;Medroxiprogesterona e seus derivados;1;KG
3354;29372321;L-Norgestrel (levonorgestrel);1;KG
3355;29372322;DL-Norgestrel;1;KG
3356;29372329;Norgestrel e outros derivados deste produto;1;KG
3357;29372331;Estriol e seu succinato;1;KG
3358;29372339;Derivados e sais do estriol;1;KG
3359;29372341;Hemissuccinato de estradiol;1;KG
3360;29372342;Fempropionato de estradiol (17-(3-fenilpropionato) de estradiol);1;KG
3361;29372349;Estradiol, outros esteres, sais e derivados;1;KG
3362;29372351;Alilestrenol;1;KG
3363;29372359;Esteres e sais de alilestrenol;1;KG
3364;29372360;Desogestrel;1;KG
3365;29372370;Linestrenol;1;KG
3366;29372391;Acetato de etinodiol;1;KG
3367;29372392;Gestodeno;1;KG
3368;29372399;Outros estrogenios e progestogenios;1;KG
3369;29372910;Metilprednisolona e seus derivados;1;KG
3370;29372920;21-Succinato sodico de hidrocortisona;1;KG
3371;29372931;Acetato de ciproterona;1;KG
3372;29372939;Ciproterona e outros derivados deste produto;1;KG
3373;29372940;Mesterolona e seus derivados;1;KG
3374;29372950;Espironolactona;1;KG
3375;29372960;Deflazacorte;1;KG
3376;29372990;Outros hormonios corticossupra-renais e seus derivados;1;KG
3377;29375000;Prostaglandinas, tromboxanas e leucotrienos, seus derivados e analogos estruturais;1;KG
3378;29379010;Tiratricol (triac) e seu sal sodico;1;KG
3379;29379030;Levotiroxina sodica;1;KG
3380;29379040;Liotironina sodica;1;KG
3381;29379090;Outros hormonios, prostaglandinas, etc.;1;KG
3382;29381000;Rutosidio (rutina) e seus derivados;1;KG
3383;29389010;Deslanosidio;1;KG
3384;29389020;Esteviosideo;1;KG
3385;29389090;Outros heterosideos, seus sais, eteres, esteres e derivados;1;KG
3386;29391110;Concentrados de palha de dormideira ou papoula;1;KG
3387;29391121;Buprenorfina e seus sais;1;KG
3388;29391122;Codeina e seus sais;1;KG
3389;29391123;Diidrocodeina e seus sais;1;KG
3390;29391131;Etilmorfina e seus sais;1;KG
3391;29391132;Etorfina e seus sais;1;KG
3392;29391140;Folcodina e seus sais;1;KG
3393;29391151;Heroina e seus sais;1;KG
3394;29391152;Hidrocodona e seus sais;1;KG
3395;29391153;Hidromorfona e seus sais;1;KG
3396;29391161;Morfina;1;KG
3397;29391162;Cloridrato e sulfato de morfina;1;KG
3398;29391169;Outros;1;KG
3399;29391170;Nicomorfina e seus sais;1;KG
3400;29391181;Oxicodona e seus sais;1;KG
3401;29391182;Oximorfona e seus sais;1;KG
3402;29391191;Tebacona e seus sais;1;KG
3403;29391192;Tebaina e seus sais;1;KG
3404;29391900;Outros alcaloides do opio, seus derivados e sais;1;KG
3405;29392000;Alcaloides da quina, seus derivados e sais;1;KG
3406;29393010;Cafeina;1;KG
3407;29393020;Sais da cafeina;1;KG
3408;29394100;Efedrina e seus sais;1;KG
3409;29394200;Pseudoefedrina (DCI) e seus sais;1;KG
3410;29394300;Catina (DCI) e seus sais;1;KG
3411;29394400;Norefedrina e seus sais;1;KG
3412;29394900;Outros derivados da efedrina e seus sais;1;KG
3413;29395100;Fenetilina (DCI) e seus sais;1;KG
3414;29395910;Teofilina;1;KG
3415;29395920;Aminofilina;1;KG
3416;29395990;Outros derivados e sais de teofilina ou aminofilina;1;KG
3417;29396100;Ergometrina (DCI) e seus sais;1;KG
3418;29396200;Ergotamina (DCI) e seus sais;1;KG
3419;29396300;Acido lisergico e seus sais;1;KG
3420;29396911;Maleato de metilergometrina;1;KG
3421;29396919;Outros derivados da ergometrina (DCI) e seus sais;1;KG
3422;29396921;Mesilato de diidroergotamina;1;KG
3423;29396929;Outros derivados da ergotamina (DCI) e seus sais;1;KG
3424;29396931;Mesilato de diidroergocornina;1;KG
3425;29396939;Ergocornina e outros derivados e sais;1;KG
3426;29396941;Mesilato de alfa-diidroergocriptina;1;KG
3427;29396942;Mesilato de beta-diidroergocriptina;1;KG
3428;29396949;Ergocriptina e outros derivados e sais;1;KG
3429;29396951;Ergocristina;1;KG
3430;29396952;Metanossulfonato de diidroergocristina;1;KG
3431;29396959;Outros derivados da ergocristina e seus sais;1;KG
3432;29396990;Outros alcaloides da cravagem do centeio, seus derivados;1;KG
3433;29397111;Cocaina e seus sais;1;KG
3434;29397112;Ecgonina e seus sais;1;KG
3435;29397119;Esteres e outros derivados de cocaina e ecgonina;1;KG
3436;29397120;Levometanfetamina, seus sais, esteres e outros derivados;1;KG
3437;29397130;Metanfetamina, seus sais, esteres e outros derivados;1;KG
3438;29397140;Racemato de metanfetamina, seus sais, esteres e outros derivados;1;KG
3439;29397911;Brometo de N-butilescopolamonio;1;KG
3440;29397919;Outras escopolaminas e seus derivados, sais destes produtos;1;KG
3441;29397920;Teobromina e seus derivados, sais destes produtos;1;KG
3442;29397931;Pilocarpina, seu nitrato e seu cloridrato;1;KG
3443;29397939;Sais de pilocarpina;1;KG
3444;29397940;Tiocolquicosido;1;KG
3445;29397990;Outros alcaloides;1;KG
3446;29398000;Outros alcaloides, naturais ou reproduzidos por sintese, seus sais, eteres, esteres e outros derivados;1;KG
3447;29400011;Galactose;1;KG
3448;29400012;Arabinose;1;KG
3449;29400013;Ramnose;1;KG
3450;29400019;Outros acucares quimicamente puros;1;KG
3451;29400021;Acido lactobionico;1;KG
3452;29400022;Lactobionato de calcio;1;KG
3453;29400023;Bromolactobionato de calcio;1;KG
3454;29400029;Outros sais, derivados halogenados, sulfonados, etc, do acido lactobionico;1;KG
3455;29400092;Frutose-1,6-difosfato de calcio ou de sodio;1;KG
3456;29400093;Maltitol;1;KG
3457;29400094;Lactogluconato de calcio;1;KG
3458;29400099;Outros eteres e esteres de acucares e seus sais;1;KG
3459;29411010;Ampicilina e seus sais;1;KG
3460;29411020;Amoxicilina e seus sais;1;KG
3461;29411031;Penicilina V potassica;1;KG
3462;29411039;Outras penicilinas V, derivados e sais;1;KG
3463;29411041;Penicilina G potassica;1;KG
3464;29411042;Penicilina G benzatinica;1;KG
3465;29411043;Penicilina G procainica;1;KG
3466;29411049;Outras penicilinas G, derivados e sais;1;KG
3467;29411090;Outras penicilinas, derivados com estrutura acido penicilanico e sais;1;KG
3468;29412010;Sulfatos de estreptomicinas;1;KG
3469;29412090;Estreptomicinas, outros derivados e sais;1;KG
3470;29413010;Cloridrato de tetraciclina;1;KG
3471;29413020;Oxitetraciclina;1;KG
3472;29413031;Minociclina;1;KG
3473;29413032;Sais de minociclina;1;KG
3474;29413090;Tetraciclina, outros derivados e sais;1;KG
3475;29414011;Cloranfenicol, seu palmitato, seu succinato e seu hemissuccinato;1;KG
3476;29414019;Outros esteres do cloranfenicol;1;KG
3477;29414020;Tianfenicol e seus esteres;1;KG
3478;29414090;Outros derivados e sais, do cloranfenicol;1;KG
3479;29415010;Claritromicina;1;KG
3480;29415020;Eritromicina e seus sais;1;KG
3481;29415090;Outros derivados da eritromicina e seus sais;1;KG
3482;29419011;Rifamicina s;1;KG
3483;29419012;Rifampicina (rifamicina amp);1;KG
3484;29419013;Rifamicina sv sodica;1;KG
3485;29419019;Outras rifamicinas, seus derivados e sais destes produtos;1;KG
3486;29419021;Cloridrato de lincomicina;1;KG
3487;29419022;Fosfato de clindamicina;1;KG
3488;29419029;Lincomicina, outros derivados e sais destes produtos;1;KG
3489;29419031;Ceftriaxona e seus sais;1;KG
3490;29419032;Cefoperazona e seus sais, e cefazolina sodica;1;KG
3491;29419033;Cefaclor e cefalexina monoidratados, e cefalotina sodica;1;KG
3492;29419034;Cefadroxil e seus sais;1;KG
3493;29419035;Cefotaxima sodica;1;KG
3494;29419036;Cefoxitina e seus sais;1;KG
3495;29419037;Cefalosporina c;1;KG
3496;29419039;Outras cefalosporinas e cefamicinas, derivados e sais;1;KG
3497;29419041;Sulfato de neomicina;1;KG
3498;29419042;Embonato de gentamicina (pamoato de gentamicina);1;KG
3499;29419043;Sulfato de gentamicina;1;KG
3500;29419049;Outros aminoglucosideos e seus sais;1;KG
3501;29419051;Embonato de espiramicina (pamoato de espiramicina);1;KG
3502;29419059;Outros macrolidios e seus sais;1;KG
3503;29419061;Nistatina e seus sais;1;KG
3504;29419062;Anfotericina b e seus sais;1;KG
3505;29419069;Outros polienos e seus sais;1;KG
3506;29419071;Monensina sodica;1;KG
3507;29419072;Narasina;1;KG
3508;29419073;Avilamicinas;1;KG
3509;29419079;Outros polieteres e seus sais;1;KG
3510;29419081;Polimixinas e seus sais;1;KG
3511;29419082;Sulfato de colistina;1;KG
3512;29419083;Virginiamicinas e seus sais;1;KG
3513;29419089;Outros polipeptidios e seus sais;1;KG
3514;29419091;Griseofulvina e seus sais;1;KG
3515;29419092;Fumarato de tiamulina;1;KG
3516;29419099;Outros antibioticos;1;KG
3517;29420000;Outros compostos organicos;1;KG
3518;30012010;Extratos de figados, para uso opoterapico;1;KG
3519;30012090;Extratos de glandulas ou de outros orgaos ou das suas secrecoes, para uso opoterapico;1;KG
3520;30019010;Heparina e seus sais;1;KG
3521;30019020;Pedacos de pericardio de origem bovina ou suina;1;KG
3522;30019031;Figados dessecados, mesmo em po;1;KG
3523;30019039;Glandulas e outros orgaos, dessecados, mesmo em po;1;KG
3524;30019090;Outras substancias humanas/animais, para fins terapeuticos/profilaticos;1;KG
3525;30021100;Estojos de diagnostico da malaria (paludismo);1;KG
3526;30021211;Antiofidicos e outros antivenenosos;1;KG
3527;30021212;Antitetanico;1;KG
3528;30021213;Anticatarral;1;KG
3529;30021214;Antipiogenico;1;KG
3530;30021215;Antidifterico;1;KG
3531;30021216;Polivalentes;1;KG
3532;30021219;Outros antissoros e outras fracoes do sangue;1;KG
3533;30021221;Imunoglobulina anti-Rh;1;KG
3534;30021222;Outras imunoglobulinas sericas;1;KG
3535;30021223;Concentrado de fator VIII;1;KG
3536;30021224;Soroalbumina, em forma de gel, para preparacao de reagentes de diagnostico;1;KG
3537;30021229;Outras fracoes do sangue, exceto as preparadas como medicamentos;1;KG
3538;30021231;Soroalbumina, exceto a humana;1;KG
3539;30021232;Plasmina (fibrinolisina);1;KG
3540;30021233;Uroquinase;1;KG
3541;30021234;Imunoglobulina e cloridrato de histamina, associados;1;KG
3542;30021235;Imunoglobulina G, liofilizada ou em solucao;1;KG
3543;30021236;Soroalbumina humana;1;KG
3544;30021239;Outras fracoes do sangue, preparadas como medicamentos;1;KG
3545;30021300;Produtos imunologicos, nao misturados, nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3546;30021410;Anticorpos monoclonais em solucao tampao, contendo albumina bovina, nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3547;30021490;Outros produtos imunologicos, misturados, nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3548;30021510;Interferon beta, peg interferon alfa-2-a;1;KG
3549;30021520;Basiliximab (DCI), bevacizumab (DCI), daclizumab (DCI), etanercept (DCI), gemtuzumab ozogamicin (DCI), oprelvekin (DCI), rituximab (DCI), trastuzumab (DCI);1;KG
3550;30021590;Outros produtos imunologicos, apresentados em doses ou acondicionados para venda a retalho;1;KG
3551;30021900;Outros antissoros, outras fracoes do sangue e produtos imunologicos, mesmo modificados ou obtidos por via biotecnologica;1;KG
3552;30022011;Vacina contra a gripe, exceto em doses;1;KG
3553;30022012;Vacina contra a poliomielite, exceto em doses;1;KG
3554;30022013;Vacina contra a hepatite B, exceto em doses;1;KG
3555;30022014;Vacina contra o sarampo, exceto em doses;1;KG
3556;30022015;Vacina contra a meningite, exceto em doses;1;KG
3557;30022016;Vacina contra a rubeola, sarampo e caxumba (triplice), exceto em doses;1;KG
3558;30022017;Outras vacinas triplices, exceto em doses;1;KG
3559;30022018;Vacinas anticatarral e antipiogenico, exceto em doses;1;KG
3560;30022019;Outras vacinas para medicina humana, exceto em doses;1;KG
3561;30022021;Vacina contra a gripe, em doses;1;KG
3562;30022022;Vacina contra a poliomielite, em doses;1;KG
3563;30022023;Vacina contra a hepatite b, em doses;1;KG
3564;30022024;Vacina contra o sarampo, em doses;1;KG
3565;30022025;Vacina contra a meningite, em doses;1;KG
3566;30022026;Vacina contra rubeola, sarampo e caxumba, em doses;1;KG
3567;30022027;Outras vacinas triplices, em doses;1;KG
3568;30022028;Vacinas anticatarral e antipiogenico, em doses;1;KG
3569;30022029;Outras vacinas para medicina humana, em doses;1;KG
3570;30023010;Vacina veterinaria, contra a raiva;1;KG
3571;30023020;Vacina veterinaria, contra a coccidiose;1;KG
3572;30023030;Vacina veterinaria, contra a querato-conjuntivite;1;KG
3573;30023040;Vacina veterinaria, contra a cinomose;1;KG
3574;30023050;Vacina veterinaria, contra a leptospirose;1;KG
3575;30023060;Vacina veterinaria, contra a febre aftosa;1;KG
3576;30023070;Vacina veterinaria contra as seguintes enfermidades: de Newcastle, a virus vivo ou virus inativo, de Gumboro, a virus vivo ou virus inativo, bronquite, a virus vivo ou virus inativo, difteroviruela, a virus vivo, etc;1;KG
3577;30023080;Vacina veterinaria combinada contra enfermidade Newcastle, Gumboro, etc;1;KG
3578;30023090;Outras vacinas para medicina veterinaria;1;KG
3579;30029010;Reagentes de origem microbiana para diagnostico;1;KG
3580;30029020;Antitoxinas de origem microbiana;1;KG
3581;30029030;Tuberculinas;1;KG
3582;30029091;Outras toxinas, culturas de microorganismos, para saude animal;1;KG
3583;30029092;Outras toxinas, culturas de microorganismos, para saude humana;1;KG
3584;30029093;Saxitoxina;1;KG
3585;30029094;Ricina;1;KG
3586;30029099;Outras toxinas, culturas de microorganismos, produtos semelhantes;1;KG
3587;30031011;Medicamento contendo ampicilina ou seus sais, exceto em doses;1;KG
3588;30031012;Medicamento contendo amoxicilina ou seus sais, exceto em doses;1;KG
3589;30031013;Medicamento contendo penicilina g benzatinica, exceto em doses;1;KG
3590;30031014;Medicamento contendo penicilina g potassica, exceto em doses;1;KG
3591;30031015;Medicamento contendo penicilina g procainica, exceto em doses;1;KG
3592;30031019;Medicamento contendo outras penicilinas/derivados, exceto em doses;1;KG
3593;30031020;Medicamento contendo estreptomicinas/derivados exceto em doses;1;KG
3594;30032011;Medicamento contendo cloranfenicol, etc.exceto em doses;1;KG
3595;30032019;Medicamento contendo anfenicois/outros derivados, exceto em doses;1;KG
3596;30032021;Medicamento contendo eritromicina/seus sais, exceto em doses;1;KG
3597;30032029;Medicamento contendo macrolidios/outros derivados, exceto em doses;1;KG
3598;30032031;Medicamento contendo rifamicina sv sodica, exceto em doses;1;KG
3599;30032032;Medicamento contendo rifampicina, exceto em doses;1;KG
3600;30032039;Medicamento contendo ansamicinas e outros derivados, exceto em doses;1;KG
3601;30032041;Medicamento contendo cloridrato de lincomicina, exceto em doses;1;KG
3602;30032049;Medicamento contendo lincosamidas/outs.derivs.exceto em doses;1;KG
3603;30032051;Medicamento contendo cefalotina sodica, exceto em doses;1;KG
3604;30032052;Medicamento contendo cefaclor/cefalexina monoidratada, exceto em doses;1;KG
3605;30032059;Medicamento contendo cefalosporinas/cefamicinas/etc, exceto em doses;1;KG
3606;30032061;Medicamento contendo sulfato de gentamicina, exceto em doses;1;KG
3607;30032062;Medicamento contendo daunorubicina, exceto em doses;1;KG
3608;30032063;Medicamento contendo pirarubicina, exceto em doses;1;KG
3609;30032069;Medicamento contendo aminoglicosidios/outros derivados, exceto em doses;1;KG
3610;30032071;Medicamento contendo vancomicina, exceto em doses;1;KG
3611;30032072;Medicamento contendo actinomicinas, exceto em doses;1;KG
3612;30032073;Medicamento com ciclosporina a, exceto em doses;1;KG
3613;30032079;Medicamento contendo polipeptidios/outros derivados, exceto em doses;1;KG
3614;30032091;Medicamento contendo mitomicina, exceto em doses;1;KG
3615;30032092;Medicamento contendo fumarato de tiamulina, exceto em doses;1;KG
3616;30032093;Medicamento contendo bleomicinas ou seus sais, exceto em doses;1;KG
3617;30032094;Medicamento contendo imipenem, exceto em doses;1;KG
3618;30032095;Medicamentos contendo anfoter.b em lipossomas, nao em doses;1;KG
3619;30032099;Medicamento contendo outros antibioticos, exceto em doses;1;KG
3620;30033100;Medicamento contendo insulina, nao contendo antibiotico, exceto em doses;1;KG
3621;30033911;Medicamento com hormonio de crescimento (somatrofina), exceto em doses;1;KG
3622;30033912;Medicamento contendo HCG (gonadotrofina corionica), exceto em doses;1;KG
3623;30033913;Medicamento contendo menotropinas, nao contendo antibiotico, exceto em doses;1;KG
3624;30033914;Medicamento contendo ACTH (corticotrofina), exceto em doses;1;KG
3625;30033915;Medicamento contendo PMSG (gonadotrofina serica), exceto em doses;1;KG
3626;30033916;Medicamento contendo somatostatina/seus sais, exceto em doses;1;KG
3627;30033917;Medicamento contendo acetato de buserelina, exceto em doses;1;KG
3628;30033918;Medicamento contendo triptorelina/seus sais, exceto em doses;1;KG
3629;30033919;Medicamento contendo leuprolida ou seu acetato, exceto em doses;1;KG
3630;30033921;Medicamento contendo lh-rh (gonadorelina), exceto em doses;1;KG
3631;30033922;Medicamento contendo oxitocina, exceto em doses;1;KG
3632;30033923;Medicamento contendo sais de insulina, exceto em doses;1;KG
3633;30033924;Medicamento contendo timosinas, exceto em doses;1;KG
3634;30033925;Medicamento contendo octretida, exceto em doses;1;KG
3635;30033926;Medicamento contendo goserelina ou seu acetato, exceto em doses;1;KG
3636;30033927;Medicamento com nafarelina ou seu acetato, exceto em doses;1;KG
3637;30033929;Medicamento contendo outros hormonios polipeptidicos, etc, exceto em doses;1;KG
3638;30033931;Medicamento contendo hemissuccinato de estradiol, exceto em doses;1;KG
3639;30033932;Medicamento contendo fempropionato de estradiol, exceto em doses;1;KG
3640;30033933;Medicamento contendo estriol ou seu succinato, exceto em doses;1;KG
3641;30033934;Medicamento contendo alilestrenol, exceto em doses;1;KG
3642;30033935;Medicamento contendo linestrenol, exceto em doses;1;KG
3643;30033936;Medicamento contendo acetato magestrol, formestano, exceto em doses;1;KG
3644;30033937;Medicamento contendo desogestrel, exceto em doses;1;KG
3645;30033939;Medicamento contendo outros estrogenios/progestogenios, exceto em doses;1;KG
3646;30033981;Medicamentos contendo levotiroxina sodica, exceto em doses;1;KG
3647;30033982;Medicamentos contendo liotironina sodica, exceto em doses;1;KG
3648;30033991;Medicamento com sal sodico ac.9, 11, 15, exceto em doses;1;KG
3649;30033992;Medicamento contendo tiratricol/seu sal sodico, exceto em doses;1;KG
3650;30033994;Medicamento contendo espironolactona, nao apresentado em doses;1;KG
3651;30033995;Medicamento contendo exemestano, exceto em doses;1;KG
3652;30033999;Outros medicamentos contendo hormonios, nao apresentados em doses;1;KG
3653;30034100;Medicamentos que contenham efedrina ou seus sais, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3654;30034200;Medicamentos que contenham pseudoefedrina (DCI) ou seus sais, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3655;30034300;Medicamentos que contenham norefedrina ou seus sais, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3656;30034910;Vimblastina, vincristina, derivados destes produtos, topotecan ou seu cloridrato, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3657;30034920;Pilocarpina, seu nitrato ou seu cloridrato, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3658;30034930;Metanossulfonato de diidroergocristina, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3659;30034940;Codeina ou seus sais, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3660;30034950;Granisetron, tropisetrona ou seu cloridrato, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3661;30034990;Outros medicamentos (exceto os produtos das posicoes 30.02, 30.05 ou 30.06) que contenham alcaloides ou seus derivados, preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3662;30036000;Outros medicamentos, que contenham principios ativos antimalaricos (antipaludicos), preparados para fins terapeuticos ou profilaticos, mas nao apresentados em doses nem acondicionados para venda a retalho;1;KG
3663;30039011;Medicamento contendo folinato calcio (leucovorina), exceto em doses;1;KG
3664;30039012;Medicamento contendo acido nicotinico, etc, exceto em doses;1;KG
3665;30039013;Medicamento contendo hidroxocobalamina, etc, exceto em doses;1;KG
3666;30039014;Medicamento contendo vitamina a1 (retinol), etc, exceto em doses;1;KG
3667;30039015;Medicamento contendo d-pantotenato de calcio, etc, exceto em doses;1;KG
3668;30039016;Medicamento contendo esteres das vitaminas A e D, etc, exceto em doses;1;KG
3669;30039017;Medicamento contendo acido retinoico (tretinoina), exceto em doses;1;KG
3670;30039019;Medicamento contendo outrasvitaminas, provitaminas derivados, exceto em doses;1;KG
3671;30039021;Medicamento contendo estreptoquinase, exceto em doses;1;KG
3672;30039022;Medicamento contendo l-asparaginase, exceto em doses;1;KG
3673;30039023;Medicamento contendo deoximbonuclease, exceto em doses;1;KG
3674;30039029;Medicamento com outras enzimas, nao contendo vitaminas, etc, exceto em doses;1;KG
3675;30039031;Medicamento contendo permetrina, etc, exceto em doses;1;KG
3676;30039032;Medicamento contendo acido deidrocolico, etc, exceto em doses;1;KG
3677;30039033;Medicamento contendo acido gluconico/sais/esteres, exceto em doses;1;KG
3678;30039034;Medicamento contendo acido o-acetilsalicilico/etc, exceto em doses;1;KG
3679;30039035;Medicamento contendo tiratricol/lactofosfato calcio, exceto em doses;1;KG
3680;30039036;Medicamento contendo acido lactico/sais/etc, exceto em doses;1;KG
3681;30039037;Medicamento contendo acido fumarico/sais/etc, exceto em doses;1;KG
3682;30039038;Medicamento contendo etretinato, miltefosina, etc, exceto em doses;1;KG
3683;30039039;Medicamento c/outs.acidos carboxilicos, etc.exceto em doses;1;KG
3684;30039041;Medicamento contendo sulfato de tranilcipromina, etc, exceto em doses;1;KG
3685;30039042;Medicamento com acido sulfanilico, sais, etc, exceto em doses;1;KG
3686;30039043;Medicamento contendo clembuterol/seu cloridrato, exceto em doses;1;KG
3687;30039044;Medicamento contendo tamoxifen/seu citrato, exceto em doses;1;KG
3688;30039045;Medicamento contendo levodopa/alfa-metildopa, exceto em doses;1;KG
3689;30039046;Medicamento contendo cloridrato de fenilefrina, etc, exceto em doses;1;KG
3690;30039047;Medicamento contendo diclofenaco de sodio, etc, exceto em doses;1;KG
3691;30039048;Medicamento contendo melfalano, clorambucil, etc, exceto em doses;1;KG
3692;30039049;Medicamento contendo outros compostos funcao amina, etc, exceto em doses;1;KG
3693;30039051;Medicamento contendo metoclopramida, etc, exceto em doses;1;KG
3694;30039052;Medicamento contendo atenolol/prilocaina/etc, exceto em doses;1;KG
3695;30039053;Medicamento contendo lidocaina/seu cloridrato, etc, exceto em doses;1;KG
3696;30039054;Medicamento contendo femproporex, exceto em doses;1;KG
3697;30039055;Medicamento contendo paracetamol ou bromoprida, exceto em doses;1;KG
3698;30039056;Medicamento contendo amitraz ou cipermetrina, exceto em doses;1;KG
3699;30039057;Medicamento contendo clorexidina/seus sais, etc, exceto em doses;1;KG
3700;30039058;Medicamento contendo carmustina/lomustina, etc, exceto em doses;1;KG
3701;30039059;Medicamento contendo outros compostos de funcao carboxiamida, etc, exceto em doses;1;KG
3702;30039061;Medicamento contendo dinitrato de isossorbida, etc, exceto em doses;1;KG
3703;30039062;Medicamento contendo tiaprida, exceto em doses;1;KG
3704;30039063;Medicamento contendo etidronato dissodico, exceto em doses;1;KG
3705;30039064;Medicamento contendo cloridrato de amiodarona, exceto em doses;1;KG
3706;30039065;Medicamento contendo nitrovin ou moxidectina, exceto em doses;1;KG
3707;30039066;Medicamento contendo espironolactona, exceto em doses;1;KG
3708;30039067;Medicamento contendo carbocisteina ou sulfiram, exceto em doses;1;KG
3709;30039069;Medicamento contendo outros tiocompostos organicos, etc.exceto em doses;1;KG
3710;30039071;Medicamento contendo terfenadina/talniflumato, etc, exceto em doses;1;KG
3711;30039072;Medicamento contendo nifedipina/nitrendipina, etc, exceto em doses;1;KG
3712;30039073;Medicamento contendo oxifendazol/albendazol, etc, exceto em doses;1;KG
3713;30039074;Medicamento contendo triazolam/alprazolam, etc, exceto em doses;1;KG
3714;30039075;Medicamento contendo fenitoina/seu sal sodico, etc, exceto em doses;1;KG
3715;30039076;Medicamento contendo acido 2-(2 metil-3 cloroanilina) nicotinico, exceto em doses;1;KG
3716;30039077;Medicamento contendo nicarbazina/norfloxacina, etc, exceto em doses;1;KG
3717;30039078;Medicamento contendo ciclosporina a, fluspirileno, etc, exceto em doses;1;KG
3718;30039079;Medicamentos contendo outros compostos heterociclicos heteroat.nitrogenados, exceto em doses;1;KG
3719;30039081;Medicamento contendo levamisol/seus sais, etc, exceto em doses;1;KG
3720;30039082;Medicamento contendo sulfadiazina/seu sal sodico, etc, exceto em doses;1;KG
3721;30039083;Medicamento contendo ketazolam/sulpirida, etc, exceto em doses;1;KG
3722;30039084;Medicamento contendo ftalilsulfatiazol/bumetanida, etc, exceto em doses;1;KG
3723;30039085;Medicamento contendo enantato de flufenazina, etc, exceto em doses;1;KG
3724;30039086;Medicamento contendo furosemida/clortalidona, etc, exceto em doses;1;KG
3725;30039087;Medicamento com cloridrato de tizanidina, etc, exceto em doses;1;KG
3726;30039088;Medicamento contendo topotecan, uracil, etc, exceto em doses;1;KG
3727;30039089;Medicamento contendo outros compostos heterociclicos, etc, exceto em doses;1;KG
3728;30039091;Medicamento contendo extrato de polen, exceto em doses;1;KG
3729;30039092;Medicamento contendo disofenol/crisarobina, etc, exceto em doses;1;KG
3730;30039093;Medicamento contendo dicoflenaco resinato, exceto em doses;1;KG
3731;30039094;Medicamento contendo silimarina, exceto em doses;1;KG
3732;30039095;Medicamento contendo propofol, busulfano, mitotano, exceto em doses;1;KG
3733;30039096;Complexo de ferro dextrana;1;KG
3734;30039099;Outros medicamentos contendo produtos misturados, para fins terapeuticos, etc;1;KG
3735;30041011;Medicamento contendo ampicilina ou seus sais, em doses;1;KG
3736;30041012;Medicamento contendo amoxicilina ou seus sais, em doses;1;KG
3737;30041013;Medicamento contendo penicilina g benzatinica, em doses;1;KG
3738;30041014;Medicamento contendo penicilina g potassica, em doses;1;KG
3739;30041015;Medicamento contendo penicilina g procainica, em doses;1;KG
3740;30041019;Medicamento cont.outs.penicilinas/seus derivs.em doses;1;KG
3741;30041020;Medicamento contendo estreptomicinas/seus derivados, em doses;1;KG
3742;30042011;Medicamento contendo cloranfenicol/seu palmitato, etc, em doses;1;KG
3743;30042019;Medicamento contendo anfenicois/outros sais, em doses;1;KG
3744;30042021;Medicamento contendo eritromicina ou seus sais, em doses;1;KG
3745;30042029;Outros medicamentos contendo macrolideos/derivados, em doses;1;KG
3746;30042031;Medicamento contendo rifamicina sv sodica, em doses;1;KG
3747;30042032;Medicamento contendo rifampicina, em doses;1;KG
3748;30042039;Outros medicamentos contendo ansamicinas/derivados, em doses;1;KG
3749;30042041;Medicamento contendo cloridrato de lincomicina, em doses;1;KG
3750;30042049;Outros medicamentos contendo lincosamidas/derivados, em dose;1;KG
3751;30042051;Medicamento contendo cafalotina sodica, em doses;1;KG
3752;30042052;Medicamento contendo cefaclor/cefalexina monoidratadas, em doses;1;KG
3753;30042059;Outros medicamentos contendo cefalosporinas, etc, em dose;1;KG
3754;30042061;Medicamento contendo sulfato de gentamicina, em doses;1;KG
3755;30042062;Medicamento contendo daunorubicina, em doses;1;KG
3756;30042063;Medicamento contendo pirarubicina, em doses;1;KG
3757;30042069;Outros medicamentos contendo aminoglucosidios/derivados, em doses;1;KG
3758;30042071;Medicamento contendo vancomicina, em doses;1;KG
3759;30042072;Medicamento contendo actinomicinas, em doses;1;KG
3760;30042073;Medicamento contendo ciclosporina A, em doses;1;KG
3761;30042079;Outros medicamentos contendo polipeptideos/derivados, em doses;1;KG
3762;30042091;Medicamento contendo mitomicina, em doses;1;KG
3763;30042092;Medicamento contendo fumarato de tiamulina, em doses;1;KG
3764;30042093;Medicamento contendo bleomicinas ou seus sais, em doses;1;KG
3765;30042094;Medicamento contendo imipenem, em doses;1;KG
3766;30042095;Medicamento contendo Anfotericina B em lipossomas, doses, venda a retalho;1;KG
3767;30042099;Medicamentos contendo outros antibioticos, em doses;1;KG
3768;30043100;Medicamentos que contenham insulina, em doses;1;KG
3769;30043210;Medicamento contendo hormonios corticosteroides, em doses;1;KG
3770;30043220;Medicamento contendo espirolactona, em doses;1;KG
3771;30043290;Medicamento contendo outros derivados de hormonios, analogos, em doses;1;KG
3772;30043911;Medicamento contendo somatotropina, em doses;1;KG
3773;30043912;Medicamento contendo gonadotropina corionica (hCG), em doses;1;KG
3774;30043913;Medicamento contendo menotropinas, em doses;1;KG
3775;30043914;Medicamento contendo corticotropina (ACTH), em doses;1;KG
3776;30043915;Medicamento contendo gonadotropina serica (PMSG), em doses;1;KG
3777;30043916;Medicamento contendo somatostatina ou seus sais, em doses;1;KG
3778;30043917;Medicamento contendo buserelina ou seu acetato, em doses;1;KG
3779;30043918;Medicamento contendo triptorelina ou seus sais, em doses;1;KG
3780;30043919;Medicamento contendo leuprolida ou seu acetato, em doses;1;KG
3781;30043921;Medicamento contendo LH-RH (gonadorelina), em doses;1;KG
3782;30043922;Medicamento contendo oxitocina, em doses;1;KG
3783;30043923;Medicamento contendo sais de insulina, em doses;1;KG
3784;30043924;Medicamento contendo timosinas, em doses;1;KG
3785;30043925;Medicamento contendo calcitonina, em doses;1;KG
3786;30043926;Medicamento contendo octreotida, em doses;1;KG
3787;30043927;Medicamento contendo goserelina ou seu acetato, em doses;1;KG
3788;30043928;Medicamento contendo nafarelina ou seu acetato, em doses;1;KG
3789;30043929;Medicamentos com outros hormonios polipeptidicos, etc, em doses;1;KG
3790;30043931;Medicamento contendo hemissuccinato de estradiol, em doses;1;KG
3791;30043932;Medicamento contendo fempropionato de estradiol, em doses;1;KG
3792;30043933;Medicamento contendo estriol ou seu succinato, em doses;1;KG
3793;30043934;Medicamento contendo alilestrenol, em doses;1;KG
3794;30043935;Medicamento contendo linestrenol, em doses;1;KG
3795;30043936;Medicamento contendo acetato de megestrol, formestano, fulvestranto, em doses;1;KG
3796;30043937;Medicamento contendo desogestrel, em doses;1;KG
3797;30043939;Medicamento contendo outros estrogenios/progestogenios, em doses;1;KG
3798;30043981;Medicamentos com levotiroxina sodica, em doses;1;KG
3799;30043982;Medicamentos com liotironina sodica, em doses;1;KG
3800;30043991;Medicamento contendo sal sodico ou ester metilico do acido 9,11,15-triidroxi-16-(3-clorofenoxi)prosta-5,13-dien-1-oico (derivado da prostaglandina F2alfa), em doses;1;KG
3801;30043992;Medicamento contendo tiratricol (triac) ou seu sal sodico, em doses;1;KG
3802;30043994;Medicamento contendo exemestano, em doses;1;KG
3803;30043999;Outros medicamentos contendo hormonios, em doses, etc;1;KG
3804;30044100;Medicamentos que contenham efedrina ou seus sais, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3805;30044200;Medicamentos que contenham pseudoefedrina (DCI) ou seus sais, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3806;30044300;Medicamentos que contenham norefedrina ou seus sais, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3807;30044910;Vimblastina, vincristina, derivados destes produtos, topotecan ou seu cloridrato, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3808;30044920;Pilocarpina, seu nitrato ou seu cloridrato, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3809;30044930;Metanossulfonato de diidroergocristina, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3810;30044940;Codeina ou seus sais, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3811;30044950;Granisetron, tropisetrona ou seu cloridrato, apresentados em doses (incluindo os destinados a serem administrados por via percutanea) ou acondicionados para venda a retalho;1;KG
3812;30044990;Outros medicamentos (exceto os produtos das posicoes 30.02, 30.05 ou 30.06);1;KG
3813;30045010;Medicamento contendo folinato de calcio (leucovorina), em doses;1;KG
3814;30045020;Medicamento contendo acido nicotinico/seu sal sodico, etc, em doses;1;KG
3815;30045030;Medicamento contendo hidroxocovalamina/seus sais, etc, em doses;1;KG
3816;30045040;Medicamento contendo vitamina a1 (retinol), etc, em doses;1;KG
3817;30045050;Medicamento contendo d-pantotenato de calcio/etc, em doses;1;KG
3818;30045060;Medicamento contendo acido retinico (tretinoina), em doses;1;KG
3819;30045090;Medicamento contendo outras vitaminas/provitaminas, etc.em doses;1;KG
3820;30046000;Outros medicamentos, que contenham principios ativos antimalaricos (antipaludicos) descritos na Nota de subposicoes 2 do presente Capitulo;1;KG
3821;30049011;Medicamento contendo estreptoquinase, em doses;1;KG
3822;30049012;Medicamento contendo l-asparaginase, em doses;1;KG
3823;30049013;Medicamento contendo deoxirribonuclease, em doses;1;KG
3824;30049019;Medicamento contendo outras enzimas, em doses;1;KG
3825;30049021;Medicamento contendo permetrina/nitrato propatila, etc, em doses;1;KG
3826;30049022;Medicamento contendo acido deidrocolico, etc, em doses;1;KG
3827;30049023;Medicamento contendo acido gluconico/sais/esteres, em doses;1;KG
3828;30049024;Medicamento contendo acido o-acetilsalicilico, etc, em doses;1;KG
3829;30049025;Medicamento contendo tiratricol/lactofosfato calcio, em doses;1;KG
3830;30049026;Medicamento contendo acido lactico/seus sais, etc, em doses;1;KG
3831;30049027;Medicamento contendo nitroglicerina, em doses, por via cutanea;1;KG
3832;30049028;Medicamento contendo etretinato, miltefosina, etc, em doses;1;KG
3833;30049029;Outros medicamentos contendo acido monocarboxilico aciclico nao saturado, exceto em doses;1;KG
3834;30049031;Medicamento contendo sulfato de tranilcipromina, etc, em doses;1;KG
3835;30049032;Medicamento contendo acido sulfanilico/seus sais, etc, em doses;1;KG
3836;30049033;Medicamento contendo clembuterol ou seu cloridrato, em doses;1;KG
3837;30049034;Medicamento contendo tamoxifen ou seu citrato, em doses;1;KG
3838;30049035;Medicamento contendo levodopa ou alfa-metildopa, em doses;1;KG
3839;30049036;Medicamento contendo cloridrato de fenilefrina, etc, em doses;1;KG
3840;30049037;Medicamento contendo diclofenaco de sodio, etc.em doses;1;KG
3841;30049038;Medicamento contendo melfalano, clorambucil, etc, em doses;1;KG
3842;30049039;Outros medicam.c/compostos de funcao amina,etc.em doses;1;KG
3843;30049041;Medicamentos contendo metoclopramida/cloridrato, etc, em doses;1;KG
3844;30049042;Medicamento contendo atenolol/prilocaina, etc, em doses;1;KG
3845;30049043;Medicamento cont.lidocaina/seu cloridrato, etc, em doses;1;KG
3846;30049044;Medicamento contendo femproporex, em doses;1;KG
3847;30049045;Medicamento contendo paracetamol ou bromoprida, em doses;1;KG
3848;30049046;Medicamento contendo amitraz ou cipermetrina, em doses;1;KG
3849;30049047;Medicamento contendo clorexidina/seus sais, etc.em doses;1;KG
3850;30049048;Medicamento contendo carmustina/lomustina, etc, em doses;1;KG
3851;30049049;Outros medicamentos com compostos de funcao carboxiamida, etc, em doses;1;KG
3852;30049051;Medicamento contendo dinitrato de isossorbida, etc, em doses;1;KG
3853;30049052;Medicamento contendo tiaprida, em doses;1;KG
3854;30049053;Medicamento contendo etidronato dissodico, em doses;1;KG
3855;30049054;Medicamento contendo cloridrato de amiodarona, em doses;1;KG
3856;30049055;Medicamento contendo nitrovin ou moxidectina, em doses;1;KG
3857;30049057;Medicamento contendo carbocisteina ou sulfiram, em doses;1;KG
3858;30049058;Medicamento contendo etoposidio, em doses;1;KG
3859;30049059;Outros medicamentos contendo produtos das posicoes 2930 a 2932, etc, em doses;1;KG
3860;30049061;Medicamento contendo terfenadina/talniflumato, etc.em doses;1;KG
3861;30049062;Medicamento cont.nifedipina/nitrendipina, etc, em doses;1;KG
3862;30049063;Medicamento contendo oxifendazol/albendazol, etc, em doses;1;KG
3863;30049064;Medicamento contendo triazolam/alprazolam, etc, em doses;1;KG
3864;30049065;Medicamento contendo fenitoina/seu sal sodico, etc, em doses;1;KG
3865;30049066;Medicamento contendo acido 2-(2-metil-3-cloroanilina) nicotinico, em doses;1;KG
3866;30049067;Medicamento contendo nicarbazina/norfloxacina, etc, em doses;1;KG
3867;30049068;Medicamento contendo ciclosporina a, fluspirileno, etc, em doses;1;KG
3868;30049069;Outros medicamentos contendo compostos heterociclicos heteroatomos nitrogenados, em doses;1;KG
3869;30049071;Medicamento contendo levamisol/seus sais/tetramisol, em doses;1;KG
3870;30049072;Medicamento contendo sulfadiazina/seu sal sodico, etc, em doses;1;KG
3871;30049073;Medicamento contendo ketazolam/sulpirida, etc, em doses;1;KG
3872;30049074;Medicamento contendo ftalilsulfatiazol/bumetanida, etc, em doses;1;KG
3873;30049075;Medicamento contendo enantato de flufenazina, etc, em doses;1;KG
3874;30049076;Medicamento contendo furosemida/clortalidona, etc, em doses;1;KG
3875;30049077;Medicamento contendo cloridrato de tizanidina, etc, em doses;1;KG
3876;30049078;Medicamento contendo topotecan, uracil, tegafur, etc, em doses;1;KG
3877;30049079;Outros medicamentos com compostos heterociclicos, etc, em doses;1;KG
3878;30049091;Medicamento contendo extrato de polen, em doses;1;KG
3879;30049092;Medicamento contendo disofenol/crisarobina, etc, em doses;1;KG
3880;30049093;Medicamento contendo diclofenaco resinato, em doses;1;KG
3881;30049094;Medicamento contendo silimarina, em doses;1;KG
3882;30049095;Medicamento contendo propofol, busulfano, mitotano, em doses;1;KG
3883;30049096;Complexo de ferro dextrana;1;KG
3884;30049099;Outros medicamentos contendo produtos para fins terapeuticos, etc, doses;1;KG
3885;30051010;Pensos adesivos impregnados/recobertos substancia farmaceutica;1;KG
3886;30051020;Pensos adesivos cirurgicos de observacao direta de feridas;1;KG
3887;30051030;Pensos adesivos impermeaveis aplicaveis sobre mucosas;1;KG
3888;30051040;Pensos adesivos com obturador, para colostomia;1;KG
3889;30051050;Pensos adesivos com fecho de correr, para fechar ferimentos;1;KG
3890;30051090;Outros pensos adesivos, artigos analogos, com camada adesiva;1;KG
3891;30059011;Pensos reabsorviveis, de acido poliglicolico;1;KG
3892;30059012;Pensos reabsorviveis de copolimero de acido glicolico/lactico;1;KG
3893;30059019;Outros pensos reabsorviveis;1;KG
3894;30059020;Campos cirurgicos, de falso tecido;1;KG
3895;30059090;Outras pastas, gazes, semelhantes, para uso medicinal, cirurgico, etc.;1;KG
3896;30061010;Materiais para suturas cirurgicas, de polidiexanona;1;KG
3897;30061020;Materiais para suturas cirurgicas, de aco inoxidavel;1;KG
3898;30061090;Outros categutes esterilizados, etc, para suturas cirurgicas;1;KG
3899;30062000;Reagentes para determinacao dos grupos/fatores sanguineos;1;KG
3900;30063011;Preparacao opacificante, de loexol, para exame radiografico;1;KG
3901;30063012;Preparacao opacificante, de iocarmato dimeglumina ou gadoterato meglumina;1;KG
3902;30063013;Preparacao opacificante, de iopamidol/iobitridol, para exame radiografico;1;KG
3903;30063015;Preparacao opacificante de dioxido de zirconio, etc, para exame radiografico;1;KG
3904;30063016;Preparacao opacificante de diatrizoato de sodio, etc, para exame radiografico;1;KG
3905;30063017;Preparacao opacificante a base de ioversol/iopromida, para exame radiografico;1;KG
3906;30063018;Preparacao opacificante de iotalamato de sodio, etc, para exame radiografico;1;KG
3907;30063019;Outras preparacoes opacificantes, para exames radiologicos;1;KG
3908;30063021;Reagente de diagnostico de somatoliberina, para administrar ao paciente;1;KG
3909;30063029;Outros reagentes de diagnostico, para ser administrado ao paciente;1;KG
3910;30064011;Cimentos para obturacao dentaria;1;KG
3911;30064012;Outros produtos para obturacao dentaria;1;KG
3912;30064020;Cimentos para reconstituicao ossea;1;KG
3913;30065000;Estojos e caixas de primeiros-socorros, guarnecidos;1;KG
3914;30066000;Prepars.quims.contraceptivas, de hormonios/espermicidas;1;KG
3915;30067000;Preparacoes em gel, utilizadas em intervencao cirurgica, etc.;1;KG
3916;30069110;Bolsas para uso em colostomia, ileostomia/urostomia;1;KG
3917;30069190;Outros equipamentos identificados para uso em ostomia;1;KG
3918;30069200;Desperdicios farmaceuticos;1;KG
3919;31010000;Adubos (fertilizantes) de origem animal ou vegetal, mesmo misturados entre si ou tratados quimicamente, adubos (fertilizantes) resultantes da mistura ou do tratamento quimico de produtos de origem animal ou vegetal;1;KG
3920;31021010;Ureia, mesmo em solucao aquosa, com teor de nitrogenio (azoto) superior a 45 %, em peso, calculado sobre o produto anidro no estado seco;1;KG
3921;31021090;Outra ureia, mesmo em solucao aquosa;1;KG
3922;31022100;Sulfato de amonio;1;KG
3923;31022910;Sulfonitrato de amonio;1;KG
3924;31022990;Outros sais duplos e misturas, de sulfato de amonio e nitrato de amonio:;1;KG
3925;31023000;Nitrato de amonio, mesmo em solucao aquosa;1;KG
3926;31024000;Misturas de nitrato de amonio com carbonato de calcio ou com outras materias inorganicas desprovidas de poder fertilizante;1;KG
3927;31025011;Nitrato de sodio, natural, com teor de nitrogenio (azoto) nao superior a 16,3 %, em peso;1;KG
3928;31025019;Outros nitratos de sodio, naturais;1;KG
3929;31025090;Outros nitratos de sodio;1;KG
3930;31026000;Sais duplos e misturas de nitrato de calcio e nitrato de amonio;1;KG
3931;31028000;Misturas de ureia com nitrato de amonio em solucoes aquosas ou amoniacais;1;KG
3932;31029000;Outros adubos ou fertilizantes minerais/quimicos, nitrogenados, incluindo as misturas nao mencionadas nas subposicoes precedentes;1;KG
3933;31031100;Superfosfatos, que contenham, em peso, 35 % ou mais de pentoxido de difosforo (P2O5);1;KG
3934;31031900;Outros superfosfatos;1;KG
3935;31039011;Hidrogeno-ortofosfato de calcio, com teor de pentoxido de fosforo (P2O5) nao superior a 46 %, em peso;1;KG
3936;31039019;Outros hidrogenos-ortofosfatos de calcio;1;KG
3937;31039090;Outros adubos ou fertilizantes minerais/quimicos, fosfatados;1;KG
3938;31042010;Cloreto de potassio, com teor de oxido de potassio (K2O) nao superior a 60 %, em peso;1;KG
3939;31042090;Outros cloretos de potassio;1;KG
3940;31043010;Sulfato de potassio, com teor de oxido de potassio (K2O) nao superior a 52 %, em peso;1;KG
3941;31043090;Outros sulfatos de potassio;1;KG
3942;31049010;Sulfato duplo de potassio e magnesio, com teor de oxido de potassio (K2O) superior a 30 %, em peso;1;KG
3943;31049090;Outros adubos ou fertilizantes minerais/quimicos, potassicos;1;KG
3944;31051000;Produtos do presente Capitulo (adubos ou fertilizantes) apresentados em tabletes ou formas semelhantes, ou ainda em embalagens com peso bruto nao superior a 10 kg;1;KG
3945;31052000;Adubos (fertilizantes) minerais ou quimicos, que contenham os tres elementos fertilizantes: nitrogenio (azoto), fosforo e potassio;1;KG
3946;31053010;Hidrogeno-ortofosfato de diamonio (fosfato diamonico ou diamoniacal), com teor de arsenio superior ou igual a 6 mg/kg;1;KG
3947;31053090;Outros hidrogeno-ortofosfato de diamonio (fosfato diamonico ou diamoniacal);1;KG
3948;31054000;Diidrogeno-ortofosfato de amonio (fosfato monoamonico ou monoamoniacal), mesmo misturado com hidrogeno-ortofosfato de diamonio (fosfato diamonico ou diamoniacal);1;KG
3949;31055100;Adubos ou fertilizantes que contenham nitratos e fosfatos;1;KG
3950;31055900;Outros adubos/fertilizantes minerais quimicos, com nitrogenio e fosforo;1;KG
3951;31056000;Adubos (fertilizantes) minerais ou quimicos, que contenham os dois elementos fertilizantes: fosforo e potassio;1;KG
3952;31059011;Nitrato de sodio potassico, com teor de nitrogenio (azoto) nao superior a 15 %, em peso, e de oxido de potassio (K2O) nao superior a 15 %, em peso;1;KG
3953;31059019;Outros nitratos de sodio potassico;1;KG
3954;31059090;Outros adubos/fertilizantes minerais quimicos com nitrogenio e potassio;1;KG
3955;32011000;Extrato tanante, de quebracho;1;KG
3956;32012000;Extrato tanante, de mimosa;1;KG
3957;32019011;Extrato tanante, de gambir;1;KG
3958;32019012;Extrato tanante, de carvalho ou de castanheiro;1;KG
3959;32019019;Outros extratos tanantes, de origem vegetal;1;KG
3960;32019020;Taninos;1;KG
3961;32019090;Sais, eteres, esteres e outros derivados dos taninos;1;KG
3962;32021000;Produtos tanantes organicos sinteticos;1;KG
3963;32029011;Produtos tanantes, a base de sais de cromo;1;KG
3964;32029012;Produtos tanantes, a base de sais de titanio;1;KG
3965;32029013;Produtos tanantes, a base de sais de zirconio;1;KG
3966;32029019;Outros produtos tanantes inorganicos;1;KG
3967;32029021;Preparacoes tanantes, a base de compostos de cromo;1;KG
3968;32029029;Outras preparacoes tanantes;1;KG
3969;32029030;Preparacoes enzimaticas, para a pre-curtimenta;1;KG
3970;32030011;Hemateina (materia corante);1;KG
3971;32030012;Fisetina (materia corante);1;KG
3972;32030013;Morina (materia corante);1;KG
3973;32030019;Outras materias corantes, de origem vegetal;1;KG
3974;32030021;Carmim de cochonilha (materia corante);1;KG
3975;32030029;Outras materias corantes, de origem animal;1;KG
3976;32030030;Preparacoes a base de materias corantes, origem vegetal/animal;1;KG
3977;32041100;Corantes dispersos e suas preparacoes;1;KG
3978;32041210;Corantes acidos, mesmo metalizados e suas preparacoes;1;KG
3979;32041220;Corantes mordentes e suas preparacoes;1;KG
3980;32041300;Corantes basicos e suas preparacoes;1;KG
3981;32041400;Corantes diretos e suas preparacoes;1;KG
3982;32041510;Corante indigo blue, segundo colour index 73000;1;KG
3983;32041520;Corante dibenzantrona;1;KG
3984;32041530;Corante 12,12-Dimetoxidibenzantrona;1;KG
3985;32041590;Outros corantes a cuba e suas preparacoes;1;KG
3986;32041600;Corantes reagentes e preparacoes a base desses corantes;1;KG
3987;32041700;Pigmentos e preparacoes a base desses pigmentos;1;KG
3988;32041911;Carotenoides;1;KG
3989;32041912;Preparacoes contendo beta-caroteno, esteres metilico ou etilico do acido 8-apo-beta-carotenoico ou cantaxantina, com oleos ou gorduras vegetais, amido, gelatina, sacarose ou dextrina, proprias para colorir alimentos;1;KG
3990;32041913;Outras preparacoes proprias para colorir alimentos;1;KG
3991;32041919;Outras preparacoes a base de caratenoides;1;KG
3992;32041920;Corantes soluveis em solventes (corantes solventes);1;KG
3993;32041930;Corantes azoicos;1;KG
3994;32041990;Outras materias corantes organicas sinteticas e suas preparacoes;1;KG
3995;32042011;Derivados do acido 4,4-bis-(1,3,5)triazinil-6-aminoestilbeno-2,2-dissulfonico;1;KG
3996;32042019;Outros derivados do estilbeno, utilizado em agente avivamente fluorescente;1;KG
3997;32042090;Outros produtos organicos sinteticos utilizados em agente avivamente fluorescente;1;KG
3998;32049000;Outras materias corantes organicas sinteticas, etc.;1;KG
3999;32050000;Lacas corantes, preparacoes indicadas na Nota 3 do presente Capitulo, a base de lacas corantes;1;KG
4000;32061111;Pigmentos tipo rutilo, com tamanho medio de particula superior ou igual a 0,6 micrometros (microns), com adicao de modificadores, com adicao de modificadores;1;KG
4001;32061119;Outros pigmentos tipo rutilo, que contenham, em peso, 80 % ou mais de dioxido de titanio, calculado sobre materia seca;1;KG
4002;32061120;Outros pigmentos que contenham, em peso, 80 % ou mais de dioxido de titanio, calculado sobre materia seca;1;KG
4003;32061130;Preparacoes a base de dioxido de titanio, peso >= 80%;1;KG
4004;32061910;Pigmento constituido por mica revestida pelicula dioxido titanio;1;KG
4005;32061990;Outros pigmentos e prepars.a base de dioxido de titanio;1;KG
4006;32062000;Pigmentos e preparacoes a base de compostos de cromo;1;KG
4007;32064100;Ultramar e suas preparacoes;1;KG
4008;32064210;Litoponio;1;KG
4009;32064290;Outs.pigmentos e preparacoes a base de sulfeto de zinco;1;KG
4010;32064910;Pigmentos preparados a base de compostos de cadmio;1;KG
4011;32064920;Pigmentos, preparados a base de hexacianoferratos;1;KG
4012;32064990;Outras materias corantes e preparacoes;1;KG
4013;32065011;Halofosfatos de calcio ou de estroncio, com substancia radioativa, utilizado em luminoforos;1;KG
4014;32065019;Outros produtos inorganicos utilizados em luminoforos, com substancia radioativa;1;KG
4015;32065021;Halofosfatos de calcio, etc, sem substancia radioativa, utilizado em luminoforos;1;KG
4016;32065029;Outros produtos inorganicos utilizados em luminoforos, sem substancia radioativa;1;KG
4017;32071010;Pigmento, opacificante, etc, a base de zirconio/seus sais;1;KG
4018;32071090;Outros pigmentos, opacificantes/cores, preparados e preparacoes;1;KG
4019;32072010;Engobos;1;KG
4020;32072091;Composicoes vitrificaveis e preparacoes utilizadas na fabricacao de circuito impresso;1;KG
4021;32072099;Outras composicoes vitrificaveis e preparacoes semelhantes;1;KG
4022;32073000;Polimentos liquidos e preparacoes semelhantes;1;KG
4023;32074010;Fritas de vidro, em po, em granulos, em lamelas ou flocos;1;KG
4024;32074090;Outros vidros em po, em granulos, em lamelas ou em flocos;1;KG
4025;32081010;Tintas de poliesteres, dispersos/dissolv.meio nao aquoso;1;KG
4026;32081020;Vernizes de poliesteres, dispersos/dissolvidos em meio nao aquoso;1;KG
4027;32081030;Solucoes de poliesteres, dispersos/dissolvidos em meio nao aquoso;1;KG
4028;32082011;Tintas a base de polimeros acrilicos, dos tipos utilizados para a fabricacao de circuitos impressos;1;KG
4029;32082019;Outras tintas a base de polimeros acrilicos ou vinilicos;1;KG
4030;32082020;Vernizes de polimeros acrilicos/vinilicos, dispersos/dissolvidos em meio nao aquoso;1;KG
4031;32082030;Solucoes de polimeros acrilicos/vinilicos, dispersos/dissolvidos em meio nao aquoso;1;KG
4032;32089010;Tintas de outros polimeros sinteticos, etc, dispersos/dissolvidos em meio nao aquoso;1;KG
4033;32089021;Vernizes de derivados de celulose, dispersos/dissolvidos em meio nao aquoso;1;KG
4034;32089029;Vernizes de outros polimeros sinteticos, etc, dispersos/dissolvidos em meio nao aquoso;1;KG
4035;32089031;Solucoes de silicones, dispersos/dissolvidos em meio nao aquoso;1;KG
4036;32089039;Outras solucoes de polimeros sinteticos, etc, dispersos/dissolvidos em meio nao aquoso;1;KG
4037;32091010;Tintas de polimeros acrilicos/vinilicos, dispersos/dissolvidos em meio aquoso;1;KG
4038;32091020;Vernizes de polimeros acrilicos/vinilicos, dispersos/dissolvidos em meio aquoso;1;KG
4039;32099011;Tintas de politetrafluoretileno, dispersas/dissolvidas em meio aquoso;1;KG
4040;32099019;Tintas de outros polimeros sinteticos, etc, dispersos/dissolvidos em meio aquoso;1;KG
4041;32099020;Vernizes de outros polimeros sinteticos, etc, dispersos/dissolvidos em meio nao aquoso;1;KG
4042;32100010;Outras tintas, dos tipos utilizados para acabamento de couros;1;KG
4043;32100020;Outros vernizes, dos tipos utilizados para acabamento de couros;1;KG
4044;32100030;Pigmentos a agua preparados, dos tipos utilizados para acabamento de couros;1;KG
4045;32110000;Secantes preparados;1;KG
4046;32121000;Folhas para marcar a ferro;1;KG
4047;32129010;Aluminio em po ou em lamelas, empastado com solvente do tipo hidrocarbonetos, com teor de aluminio superior ou igual a 60 %, em peso;1;KG
4048;32129090;Outros pigmentos dispersos em meios nao aquosos, estado liquido, etc.;1;KG
4049;32131000;Cores em sortidos para pintura artistica, atividade educativa, etc.;1;KG
4050;32139000;Outras cores para pintura artistica, atividade educativa, etc.;1;KG
4051;32141010;Mastique de vidraceiro, cimentos de resinas, outros mastiques;1;KG
4052;32141020;Indutos utilizados em pintura;1;KG
4053;32149000;Indutos nao refratrarios dos tipos utilizados em alvenaria;1;KG
4054;32151100;Tintas pretas, de impressao;1;KG
4055;32151900;Outras tintas de impressao;1;KG
4056;32159000;Tintas de escrever ou de desenhar e outras tintas, mesmo concentradas ou no estado solido;1;KG
4057;33011210;Oleo essencial, de laranja, de petit grain;1;KG
4058;33011290;Outros oleos essenciais, de laranja;1;KG
4059;33011300;Oleo essencial, de limao;1;KG
4060;33011910;Oleos essenciais de lima;1;KG
4061;33011990;Outros oleos essenciais de citricos;1;KG
4062;33012400;Oleo essencial, de hortela-pimenta (Mentha piperita);1;KG
4063;33012510;Oleo essencial, de menta japonesa (Mentha arvensis);1;KG
4064;33012520;Oleo essencial, de mentha spearmint (Mentha viridis L.);1;KG
4065;33012590;Oleo essencial, de outras mentas;1;KG
4066;33012911;Oleo essencial, de citronela;1;KG
4067;33012912;Oleo essencial, de cedro;1;KG
4068;33012913;Oleo essencial, de pau-santo (Bulnesia sarmientol);1;KG
4069;33012914;Oleo essencial, de lemongrass;1;KG
4070;33012915;Oleo essencial, de pau-rosa;1;KG
4071;33012916;Oleo essencial, de palma rosa;1;KG
4072;33012917;Oleo essencial, de coriandro;1;KG
4073;33012918;Oleo essencial, de cabreuva (cabriuva);1;KG
4074;33012919;Oleo essencial, de eucalipto;1;KG
4075;33012921;Oleos essenciais de alfazema ou de lavanda;1;KG
4076;33012922;Oleos essenciais de vetiver;1;KG
4077;33012990;Outros oleos essenciais;1;KG
4078;33013000;Resinoides;1;KG
4079;33019010;Solucoes concentradas de oleos essenciais em gorduras, em oleos fixos, em ceras ou em materias analogas, obtidas por tratamento de flores atraves de substancias gordas ou por maceracao;1;KG
4080;33019020;Subprodutos terpenicos residuais da desterpenacao dos oleos essenciais;1;KG
4081;33019030;Aguas destiladas aromaticas e solucoes aquosas de oleos essenciais;1;KG
4082;33019040;Oleorresinas de extracao;1;KG
4083;33021000;Misturas utilizadas em materia basica para industria alimentar/de bebida;1;KG
4084;33029011;Vetiverol para perfumaria;1;KG
4085;33029019;Outras misturas utilizadas como materia basica para perfumaria;1;KG
4086;33029090;Outras misturas utilizadas como materia basica para industria;1;KG
4087;33030010;Perfumes (extratos);1;KG
4088;33030020;Aguas-de-colonia;1;KG
4089;33041000;Produtos de maquiagem para os labios;1;KG
4090;33042010;Sombra, delineador, lapis para sobrancelhas e rimel (produtos de maquiagem para os olhos);1;KG
4091;33042090;Outros produtos de maquiagem para os olhos;1;KG
4092;33043000;Preparacoes para manicuros e pedicuros;1;KG
4093;33049100;Pos, incluidos os compactos, para maquiagem;1;KG
4094;33049910;Cremes de beleza e cremes nutritivos, locoes tonicas;1;KG
4095;33049990;Outros produtos de beleza ou de maquiagem preparados, etc;1;KG
4096;33051000;Xampus para os cabelos;1;KG
4097;33052000;Preparacoes para ondulacao ou alisamento, permanentes, dos cabelos;1;KG
4098;33053000;Laques para o cabelo;1;KG
4099;33059000;Outras preparacoes capilares;1;KG
4100;33061000;Dentifricios;1;KG
4101;33062000;Fios utilizados para limpar os espacos interdentais (fios dentais);1;KG
4102;33069000;Outras preparacoes para higiene bucal ou dentaria, etc.;1;KG
4103;33071000;Preparacoes para barbear (antes, durante ou apos);1;KG
4104;33072010;Desodorantes (desodorizantes) corporais e antiperspirantes, liquidos;1;KG
4105;33072090;Desodorantes (desodorizantes) corporais e antiperspirantes, em outras formas;1;KG
4106;33073000;Sais perfumados e outras preparacoes para banhos;1;KG
4107;33074100;Agarbate e outras preparacoes odoriferas que atuem por combustao;1;KG
4108;33074900;Outras preparacoes para perfumar ou desodorizar ambientes;1;KG
4109;33079000;Outros produtos de perfumaria ou toucador, preparados, etc.;1;KG
4110;34011110;Saboes medicinais, em barras, pedacos, figura moldada, etc.;1;KG
4111;34011190;Outros produtos/preparacoes de toucador, em barras, pedacos, etc.;1;KG
4112;34011900;Outros saboes/produtos/preparacoes, em barras, pedacos, etc.;1;KG
4113;34012010;Saboes de toucador, sob outras formas;1;KG
4114;34012090;Outros saboes;1;KG
4115;34013000;Produtos e preparacoes organanicas tensoativos, para lavar pele;1;KG
4116;34021110;Dibutilnaftalenossulfato de sodio (agente organico de superficie);1;KG
4117;34021120;N-metil-n-oleitaurato de sodio (agente organico de superficie);1;KG
4118;34021130;Alquilsulfonato de sodio, secundario (agente organico de superficie);1;KG
4119;34021140;Mistura de acidos alquilbenzenossulfonicos;1;KG
4120;34021190;Outros agentes organicos de superficie, anionicos;1;KG
4121;34021210;Acetato de oleilamina (agente organico de superficie);1;KG
4122;34021290;Outros agentes organicos de superficie, cationicos;1;KG
4123;34021300;Agentes organicos de superficie, nao ionicos;1;KG
4124;34021900;Outros agentes organicos de superficie;1;KG
4125;34022000;Preparacoes tensoativas, para lavagem e limpeza;1;KG
4126;34029011;Misturas entre si de agentes organicos de superficie, que contenham exclusivamente produtos nao ionicos;1;KG
4127;34029019;Outras misturas de agentes organicos de superficie;1;KG
4128;34029021;Solucoes ou emulsoes hidroalcoolicas de (1-perfluoralquil-2-acetoxi)propil-betaina;1;KG
4129;34029022;Solucoes, etc, a base de nonanoiloxibenzenossulfonato de sodio;1;KG
4130;34029023;Solucoes ou emulsoes hidroalcoolicas de sulfonatos de perfluoralquiltrimetilamonio e de perfluoralquilacrilamida;1;KG
4131;34029029;Outras solucoes ou emulsoes de produtos tensoativos, etc;1;KG
4132;34029031;Preparacoes para lavagem (detergentes), a base de nonilfenol etoxilado;1;KG
4133;34029039;Outras preparacoes para lavagem (detergentes);1;KG
4134;34029090;Outras preparacoes tensoativas e preparacoes para limpeza;1;KG
4135;34031110;Preparacoes para o tratamento de materias texteis, que contenham oleos de petroleo ou de minerais betuminosos;1;KG
4136;34031120;Preparacoes para o tratamento de couros e peles, que contenham oleos de petroleo ou de minerais betuminosos;1;KG
4137;34031190;Preparacoes para o tratamento de outras materias, que contenham oleos de petroleo ou de minerais betuminosos;1;KG
4138;34031900;Outras preparacoes que contenham oleos de petroleo ou de minerais betuminosos;1;KG
4139;34039110;Outras preparacoes para o tratamento de materias texteis;1;KG
4140;34039120;Outras preparacoes para o tratamento de couros e peles;1;KG
4141;34039190;Outras preparacoes para o tratamento de outras materias;1;KG
4142;34039900;Outras preparacoes lubrificantes/antiaderentes/antiferrugem, etc;1;KG
4143;34042010;Ceras artificiais de poli(oxietileno) (polietilenoglicol);1;KG
4144;34042020;Ceras preparadas de poli(oxietileno) (polietilenoglicol);1;KG
4145;34049011;Cera artificial de polietileno, emulsionaveis;1;KG
4146;34049012;Outras ceras artificiais, de polietileno;1;KG
4147;34049013;Cera artificial de polipropilenoglicois;1;KG
4148;34049014;Ceras artificiais de dimero de alquilceteno com dois grupos alternados n-alquila de C12, C14 e C16, em granulos;1;KG
4149;34049019;Outras ceras artificiais;1;KG
4150;34049021;Cera preparada a base de vaselina e alcoois de lanolina (eucerina anidra);1;KG
4151;34049029;Outras ceras preparadas;1;KG
4152;34051000;Pomadas, cremes e preparacoes semelhantes, para calcados ou para couros;1;KG
4153;34052000;Encausticas e preparacoes semelhantes, para conservacao e limpeza de moveis de madeira, soalhos e de outros artigos de madeira;1;KG
4154;34053000;Preparacoes para dar brilho a pinturas de carrocarias e produtos semelhantes, exceto preparacoes para dar brilho a metais;1;KG
4155;34054000;Pastas, pos e outras preparacoes para arear;1;KG
4156;34059000;Outras preparacoes para dar brilho em vidros, metais, etc.;1;KG
4157;34060000;Velas, pavios, cirios e artigos semelhantes;1;KG
4158;34070010;Pastas para modelar;1;KG
4159;34070020;Ceras para dentistas;1;KG
4160;34070090;Outras composicoes para dentistas, a base de gesso;1;KG
4161;35011000;Caseinas;1;KG
4162;35019011;Caseinato de sodio;1;KG
4163;35019019;Outros caseinatos e derivados das caseinas;1;KG
4164;35019020;Colas de caseina;1;KG
4165;35021100;Ovalbumina seca;1;KG
4166;35021900;Outras ovalbuminas;1;KG
4167;35022000;Lactalbumina, incluindo os concentrados de duas ou mais proteinas de soro de leite;1;KG
4168;35029010;Soroalbumina;1;KG
4169;35029090;Outras albuminas, albuminatos e outros derivados das albuminas;1;KG
4170;35030011;Gelatinas e seus derivados, de osseina, com grau de pureza superior ou igual a 99,98 %, em peso;1;KG
4171;35030012;Gelatinas e seus derivados, de osseina, com grau de pureza inferior a 99,98 %, em peso;1;KG
4172;35030019;Outras gelatinas e seus derivados;1;KG
4173;35030090;Ictiocola, outras colas de origem animal, exceto cola de caseina;1;KG
4174;35040011;Peptonas e peptonatos;1;KG
4175;35040019;Outros derivados das peptonas;1;KG
4176;35040020;Proteinas de soja em po, com teor de proteinas superior ou igual a 90 %, em peso, em base seca;1;KG
4177;35040030;Proteinas de batata em po, com teor de proteinas superior ou igual a 80 %, em peso, em base seca;1;KG
4178;35040090;Outras materias proteicas, seus derivados e po de peles;1;KG
4179;35051000;Dextrina e outros amidos e feculas modificados;1;KG
4180;35052000;Colas a base de amidos ou de feculas, de dextrina, etc.;1;KG
4181;35061010;Produtos de qualquer especie utilizados como colas ou adesivos, acondicionados para venda a retalho como colas ou adesivos, com peso liquido nao superior a 1 kg, a base de cianoacrilatos;1;KG
4182;35061090;Outros produtos de qualquer especie utilizados como colas ou adesivos, acondicionados para venda a retalho como colas ou adesivos, com peso liquido nao superior a 1 kg,;1;KG
4183;35069110;Adesivos a base de borracha;1;KG
4184;35069120;Adesivos a base de polimeros das posicoes 39.01 a 39.13, dispersos ou para dispersar em meio aquoso;1;KG
4185;35069190;Outros adesivos a base de plasticos;1;KG
4186;35069900;Outras colas e adesivos preparados;1;KG
4187;35071000;Coalho e seus concentrados;1;KG
4188;35079011;Alfa-amilase (Aspergillus oryzae);1;KG
4189;35079019;Outras amilases e seus concentrados;1;KG
4190;35079021;Fibrinucleases;1;KG
4191;35079022;Bromelina;1;KG
4192;35079023;Estreptoquinase;1;KG
4193;35079024;Estreptodornase;1;KG
4194;35079025;Mistura de estreptoquinase e estreptodornase;1;KG
4195;35079026;Papaina;1;KG
4196;35079029;Outras proteases e seus concentrados;1;KG
4197;35079031;Lisozima e seu cloridrato;1;KG
4198;35079032;L-Asparaginase;1;KG
4199;35079039;Outras enzimas e seus concentrados;1;KG
4200;35079041;Enzimas preparadas a base de celulases;1;KG
4201;35079042;Enzimas preparadas a base de transglutaminase;1;KG
4202;35079049;Outras enzimas preparadas;1;KG
4203;36010000;Polvoras propulsivas;1;KG
4204;36020000;Explosivos preparados, exceto polvoras propulsivas;1;KG
4205;36030000;Estopins e rastilhos, de seguranca, cordeis detonantes, fulminantes e capsulas fulminantes, escorvas, detonadores eletricos;1;KG
4206;36041000;Fogos de artificio;1;KG
4207;36049010;Foguetes e cartuchos contra o granizo e semelhantes;1;KG
4208;36049090;Outros foguetes de sinalizacao e artigos de pirotecnia;1;KG
4209;36050000;Fosforos, exceto os artigos de pirotecnia da posicao 36.04;1;KG
4210;36061000;Combustiveis liquidos e combustiveis gasosos liquefeitos, em recipientes dos tipos utilizados para carregar ou recarregar isqueiros ou acendedores, com capacidade nao superior a 300 cm3;1;KG
4211;36069000;Ferrocerio e outras ligas pirofosforicas, artigo de material inflamavel;1;KG
4212;37011010;Chapas e filmes planos, para raios X, sensibilizados em uma face, nao impressionados;1;M2
4213;37011021;Chapas e filmes planos para raios X, sensibilizados nas duas faces, proprios para uso odontologico, nao impressionados;1;M2
4214;37011029;Outras chapas e filmes planos para raios X, sensibilizados nas duas faces, nao impressionados;1;M2
4215;37012010;Filmes de revelacao e copiagem instantaneas, para fotografia a cores (policromo);1;KG
4216;37012020;Filmes de revelacao e copiagem instantaneas, para fotografia monocromatica;1;KG
4217;37013010;Outras chapas e filmes cuja dimensao de pelo menos um dos lados seja superior a 255 mm, para fotografia a cores (policromo);1;M2
4218;37013021;Chapas sensibilizadas com polimeros fotossensiveis, de aluminio, cuja dimensao de pelo menos um dos lados seja superior a 255 mm;1;M2
4219;37013022;Chapas sensibilizadas com polimeros fotossensiveis, de poliester, cuja dimensao de pelo menos um dos lados seja superior a 255 mm;1;M2
4220;37013029;Outras chapas sensibilizadas com polimeros fotossensiveis, cuja dimensao de pelo menos um dos lados seja superior a 255 mm;1;M2
4221;37013031;Chapas sensibilizadas por outros procedimentos, de aluminio, cuja dimensao de pelo menos um dos lados seja superior a 255 mm;1;M2
4222;37013039;Outras chapas sensibilizadas por outros procedimentos, cuja dimensao de pelo menos um dos lados seja superior a 255 mm;1;M2
4223;37013040;Filmes para as artes graficas;1;M2
4224;37013050;Filmes heliograficos, de poliester;1;M2
4225;37013090;Outras chapas e filmes planos, sensibilizados, nao impressionados, dimensao > 255 mm;1;M2
4226;37019100;Outras chapas e filmes planos, sensibilizados, nao impressionados, para fotografia a cores (policromo);1;KG
4227;37019900;Outras chapas e filmes planos, sensibilizados, nao impressionados para fotografia monocromatica;1;M2
4228;37021010;Filmes para raios X, sensibilizados em uma face, nao impressionados, em rolos;1;M2
4229;37021020;Filmes para raios X, sensibilizados em ambas as faces, nao impressionados, em rolos;1;M2
4230;37023100;Outros filmes, nao perfurados, de largura nao superior a 105 mm, para fotografia a cores (policromo;1;UN
4231;37023200;Outros filmes, nao perfurados, de largura nao superior a 105 mm, que contenham uma emulsao de halogenetos de prata;1;M2
4232;37023900;Outros filmes nao perfurados, sensibilizados, nao impressos, de largura nao superior a 105 mm, em rolos;1;M2
4233;37024100;Outros filmes, nao perfurados, de largura superior a 610 mm e comprimento superior a 200 m, para fotografia a cores (policromo);1;M2
4234;37024210;Filmes para as artes graficas, sensibilizados, nao impressionados, em rolos, de largura superior a 610 mm e comprimento superior a 200 m, exceto para fotografia a cores (policromo);1;M2
4235;37024290;Outros filmes, sensibilizados, nao impressionados, em rolos, de largura superior a 610 mm e comprimento superior a 200 m, exceto para fotografia a cores (policromo);1;M2
4236;37024310;Filmes para as artes graficas, sensibilizados, nao impressionados, em rolos, de largura superior a 610 mm e comprimento nao superior a 200 m;1;M2
4237;37024320;Filmes heliograficos, de poliester, sensibilizados, nao impressionados, em rolos, de largura superior a 610 mm e comprimento nao superior a 200 m;1;M2
4238;37024390;Outros filmes, sensibilizados, nao impressionados, em rolos, de largura superior a 610 mm e comprimento nao superior a 200 m;1;M2
4239;37024410;Filmes de largura superior a 105 mm, mas nao superior a 610 mm, sensibilizado, nao impressionado, para fotografia a cores (policromo);1;M2
4240;37024421;Filmes para as artes graficas, de largura superior a 105 mm, mas nao superior a 610 mm, sensibilizado, nao impressionado, para fotografia monocromatica;1;M2
4241;37024422;Fotopolimerizaveis, sensibilizadas a base de compostos acrilicos, dos tipos utilizados para a fabricacao de circuitos impressos, de largura superior a 105 mm, mas nao superior a 610 mm;1;M2
4242;37024429;Outros filmes para fotografia monocromatica, sensibilizados, nao impressionados, de largura superior a 105 mm, mas nao superior a 610 mm, em rolos;1;M2
4243;37025200;Outros filmes, para fotografia a cores (policromo), sensibilizado, nao impressionado, de largura nao superior a 16 mm, em rolos;1;METRO
4244;37025300;Outros filmes, para fotografia a cores (policromo), sensibilizado, nao impressionado, de largura superior a 16 mm, mas nao superior a 35 mm, e comprimento nao superior a 30 m, para diapositivos;1;METRO
4245;37025411;Outros filmes, para fotografia a cores (policromo), de largura igual a 35 mm, exceto para diapositivos, em bobinas (filmpacks);1;METRO
4246;37025412;Outros filmes, para fotografia a cores (policromo), de largura igual a 35 mm, exceto para diapositivos, de 12 exposicoes (0,5 m de comprimento), de 24 exposicoes (1,0 m de comprimento) ou de 36 exposicoes (1,5 m de comprimento);1;METRO
4247;37025419;Outros filmes para foto a cores, nao impressionados, largura = 35 mm, comprimento <= 30 m, em rolos;1;METRO
4248;37025491;Filmes para foto a cores, nao impressionados, de largura superior a 16 mm, mas nao superior a 35 mm, e comprimento nao superior a 30 m, exceto para diapositivos, em bobinas (filmpacks);1;METRO
4249;37025499;Outros filmes para foto a cores, nao impressionado, de largura superior a 16 mm, mas nao superior a 35 mm, e comprimento nao superior a 30 m, em rolos;1;METRO
4250;37025510;Filmes para foto a cores, sensibilizado, nao impressionado, ee largura igual a 35 mm e comprimento superior a 30 m, em rolos;1;METRO
4251;37025590;Filmes para foto a cores, sensibilizado, nao impressionado, de largura superior a 16 mm, mas nao superior a 35 mm, e comprimento superior a 30 m, em rolos;1;METRO
4252;37025600;Filmes para foto a cores, sensibilizados, nao impressionados, de largura superior a 35 mm, em rolos;1;METRO
4253;37029600;Outros filmes sensibilizados, nao impressionados, de largura nao superior a 35 mm e comprimento nao superior a 30 m;1;METRO
4254;37029700;Outros filmes sensibilizados, nao impressionados, de largura nao superior a 35 mm e comprimento superior a 30 m;1;METRO
4255;37029800;Outros filmes sensibilizados, nao impressionados, de largura superior a 35 mm;1;METRO
4256;37031010;Papeis, cartoes e texteis, fotograficos, sensibilizados, nao impressionados, em rolos de largura superior a 610 mm, para fotografia a cores (policromo);1;KG
4257;37031021;Papel heliografico, nao impressionados, em rolos de largura superior a 610 mm, para fotografia a cores (policromo), para fotografia monocromatica;1;KG
4258;37031029;Outros papeis para fotografia monocromatica, sensibilizado, nao impressionado, em rolos, largura > 610 mm;1;KG
4259;37032000;Outros papeis para foto a cores, sensibilizados, nao impressionados;1;KG
4260;37039010;Papel para fotocomposicao, sensibilizado, nao impressionado;1;KG
4261;37039090;Outros papeis, cartoes e texteis fotograficos, sensibilizados, nao impressionados;1;KG
4262;37040000;Chapas, filmes, papeis, cartoes e texteis, fotograficos, impressionados mas nao revelados;1;KG
4263;37050010;Fotomascaras sobre vidro plano, positivas, proprias para gravacao em pastilhas de silicio (chips) para fabricacao de microestruturas eletronicas;1;KG
4264;37050090;Outras chapas e filmes, fotograficos, impressionados e revelados, exceto os filmes cinematograficos;1;KG
4265;37061000;Filmes cinematograficos impressos e revelados, largura >= 35 mm;1;METRO
4266;37069000;Outros filmes cinematograficos impressos e revelados;1;METRO
4267;37071000;Emulsoes para sensibilizacao de superficies, para uso fotografico;1;KG
4268;37079010;Fixadores para uso fotografico;1;KG
4269;37079021;Reveladores a base de negro-de-carbono ou de um corante e resinas termoplasticas, para a reproducao de documentos por processo eletrostatico;1;KG
4270;37079029;Outros reveladores para uso fotografico;1;KG
4271;37079030;Compostos diazoicos fotossensiveis para preparacao de emulsoes;1;KG
4272;37079090;Outras preparacoes quimicas para usos fotograficos, etc.;1;KG
4273;38011000;Grafita artificial;1;KG
4274;38012010;Suspensao semicoloidal em oleos minerais;1;KG
4275;38012090;Outras grafitas coloidais ou semicoloidais;1;KG
4276;38013010;Pasta carbonada para eletrodos;1;KG
4277;38013090;Pastas semelhantes as carbonadas, para revestimento interior de fornos;1;KG
4278;38019000;Outras preparacoes a base de grafita/outros carbonos, em pasta, etc;1;KG
4279;38021000;Carvoes ativados;1;KG
4280;38029010;Farinhas siliciosas fosseis (ativadas);1;KG
4281;38029020;Bentonita (materia mineral natural ativada);1;KG
4282;38029030;Atapulgita;1;KG
4283;38029040;Outras argilas e terras ativadas;1;KG
4284;38029050;Bauxita (materia mineral natural ativada);1;KG
4285;38029090;Outras materias minerais naturais ativadas, etc.;1;KG
4286;38030010;Tall oil, mesmo refinado, em bruto;1;KG
4287;38030090;Tall oil, mesmo refinado, em outra forma que nao bruto;1;KG
4288;38040011;Lixivias residuais da fabricacao de pastas de celulose, ao sulfito;1;KG
4289;38040012;Lixivias residuais da fabricacao de pastas de celulose, a soda ou ao sulfato;1;KG
4290;38040020;Lignossulfonatos;1;KG
4291;38051000;Essencias de terebintina, de pinheiro ou provenientes da fabricacao da pasta de papel ao sulfato;1;KG
4292;38059010;Oleo de pinho;1;KG
4293;38059090;Outras essencias terpenicas de fabricacao de madeira/papel;1;KG
4294;38061000;Colofonias e acidos resinicos;1;KG
4295;38062000;Sais de colofonias, de acidos resinicos ou de derivados de colofonias ou de acidos resinicos, exceto os sais de aductos de colofonias;1;KG
4296;38063000;Gomas esteres;1;KG
4297;38069011;Colofonias oxidadas, hidrogenadas, desidrogenadas, polimerizadas ou modificadas com acidos fumarico ou maleico ou com anidrido maleico;1;KG
4298;38069012;Abietatos de metila ou de benzila, hidroabietato de metila;1;KG
4299;38069019;Outros derivados de colofonias ou de acidos resinicos;1;KG
4300;38069090;Outras essencias de colofonia e oleos de colofonia;1;KG
4301;38070000;Alcatroes de madeira, oleos de alcatrao de madeira, creosoto de madeira, metileno, breu (pez) vegetal, breu (pez) para a industria da cerveja e preparacoes semelhantes a base de colofonias, de acidos resinicos ou de breu (pez) vegetal;1;KG
4302;38085200;DDT (ISO) (clofenotano (DCI)), acondicionado em embalagens com um conteudo de peso liquido nao superior a 300 gramas;1;KG
4303;38085910;Outras mercadorias mencionadas na Nota de subposicoes 1 do presente Capitulo, apresentadas em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4304;38085921;Mercadorias a base de metamidofos (ISO) ou monocrotofos (ISO), apresentadas de outro modo;1;KG
4305;38085922;Mercadorias a base de endossulfan (ISO), apresentadas de outro modo;1;KG
4306;38085923;Mercadorias a base de alaclor (ISO), apresentadas de outro modo;1;KG
4307;38085929;Mercadorias a base de outras substancias, apresentadas de outro modo;1;KG
4308;38086100;Mercadorias mencionadas na Nota de subposicoes 2 do presente Capitulo, acondicionadas em embalagens com um conteudo de peso liquido nao superior a 300 g;1;KG
4309;38086210;Mercadorias mencionadas na Nota de subposicoes 2 do presente Capitulo, acondicionadas em embalagens com um conteudo de peso liquido superior a 300 g, mas nao superior a 7,5 kg, a base de alfa-cipermetrina (ISO);1;KG
4310;38086290;Outras mercadorias mencionadas na Nota de subposicoes 2 do presente Capitulo, acondicionadas em embalagens com um conteudo de peso liquido nao superior a 300 g;1;KG
4311;38086910;Outras mercadorias mencionadas na Nota de subposicoes 2 do presente Capitulo, a base de alfa-cipermetrina (ISO);1;KG
4312;38086990;Outras mercadorias mencionadas na Nota de subposicoes 2 do presente Capitulo,;1;KG
4313;38089111;Inseticidas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4314;38089119;Outros inseticidas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4315;38089120;Inseticidas apresentados de outro modo, contendo bromometano (brometo de metila) ou bromoclorometano;1;KG
4316;38089191;Inseticida a base de acefato ou de Bacillus thuringiensis, apresentado de outro modo;1;KG
4317;38089192;Inseticida a base de cipermetrinas ou de permetrina, apresentado de outro modo;1;KG
4318;38089193;Inseticida a base de dicrotofos, apresentado de outro modo;1;KG
4319;38089194;Inseticida a base de dissulfoton ou de endossulfan, apresentado de outro modo;1;KG
4320;38089195;Inseticida a base de fosfeto de aluminio, apresentado de outro modo;1;KG
4321;38089196;Inseticida a base de diclorvos ou de triclorfon, apresentado de outro modo;1;KG
4322;38089197;Inseticida a base de oleo mineral ou de tiometon, apresentado de outro modo;1;KG
4323;38089198;Inseticida a base de sulfluramida, apresentado de outro modo;1;KG
4324;38089199;Outros inseticidas, apresentados de outro modo;1;KG
4325;38089211;Fungicidas, apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4326;38089219;Outros fungicidas, apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4327;38089220;Fungicidas apresentados de outro modo, contendo bromometano (brometo de metila) ou bromoclorometano;1;KG
4328;38089291;Fungicidas a base de hidroxido de cobre, de oxicloreto de cobre ou de oxido cuproso;1;KG
4329;38089292;Fungicida a base de enxofre ou de ziram;1;KG
4330;38089293;Fungicida a base de mancozeb ou de maneb;1;KG
4331;38089294;Fungicida a base de sulfiram;1;KG
4332;38089295;Fungicida a base de compostos de arsenio, cobre ou cromo, exceto os produtos do subitem 3808.92.91;1;KG
4333;38089296;Fungicida a base de thiram;1;KG
4334;38089297;Fungicida a base de propiconazol;1;KG
4335;38089299;Outros fungicidas apresentados de outro modo;1;KG
4336;38089311;Herbicidas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4337;38089319;Outros herbicidas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4338;38089321;Herbicidas apresentados de outro modo, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4339;38089322;Outros herbicidas apresentados de outro modo, a base de acido 2,4-diclorofenoxiacetico (2,4-D), de acido 4-(2,4-diclorofenoxi)butirico (2,4-DB), de acido (4-cloro-2-metil)fenoxiacetico (MCPA) ou de derivados de 2,4-D ou 2,4-DB;1;KG
4340;38089323;Herbicida a base de alaclor, de ametrina, de atrazina ou de diuron;1;KG
4341;38089324;Herbicida a base de glifosato ou seus sais, de imazaquim ou de lactofen;1;KG
4342;38089325;Herbicida a base de dicloreto de paraquat, de propanil ou de simazina;1;KG
4343;38089326;Herbicida a base de trifluralina;1;KG
4344;38089327;Herbicida a base de imazetapir;1;KG
4345;38089328;Herbicidas a base de hexazinona;1;KG
4346;38089329;Outros herbicidas apresentados de outro modo;1;KG
4347;38089331;Inibidores de germinacao, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4348;38089332;Outros inibidores de germinacao, embalado para uso domissanitario direto;1;KG
4349;38089333;Outros inibidores de germinacao apresentados de outro modo;1;KG
4350;38089341;Reguladores de crescimento das plantas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4351;38089349;Outros reguladores de crescimento das plantas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4352;38089351;Reguladores de crescimento das plantas, apresentados de outro modo, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4353;38089352;Reguladores de crescimento das plantas, apresentados de outro modo, a base de hidrazida maleica;1;KG
4354;38089359;Outros reguladores de crescimento das plantas, apresentados de outro modo;1;KG
4355;38089411;Desinfetantes, apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4356;38089419;Outros desinfetantes, apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4357;38089421;Desinfetantes apresentados de outro modo, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4358;38089422;Desinfetantes apresentados de outro modo, a base de 2-(tiocianometiltio) benzotiazol;1;KG
4359;38089429;Outros desinfetantes apresentados de outro modo;1;KG
4360;38089911;Rodenticidas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias, que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4361;38089919;Outros rodenticidas apresentados em formas ou embalagens exclusivamente para uso direto em aplicacoes domissanitarias;1;KG
4362;38089920;Outros rodenticidas apresentados de outro modo, contendo bromometano (brometo de metila) ou bromoclorometano;1;KG
4363;38089991;Acaricidas a base de amitraz, de clorfenvinfos ou de propargite;1;KG
4364;38089992;Acaricidas a base de ciexatin ou de oxido de fembutatin (oxido de fenbutatin);1;KG
4365;38089993;Outros acaricidas;1;KG
4366;38089994;Nematicidas a base de metam sodio;1;KG
4367;38089995;Outros nematicidas apresentados de outro modo;1;KG
4368;38089996;Raticidas apresentados de outro modo;1;KG
4369;38089999;Outros rodenticidas apresentados de outro modo;1;KG
4370;38091010;Preparacoes a base de materias amilaceas para industria textil;1;KG
4371;38091090;Outras preparacoes a base de materias amilaceas;1;KG
4372;38099110;Aprestos preparados dos tipos utilizados na industria textil ou nas industrias semelhantes;1;KG
4373;38099120;Preparacoes mordentes dos tipos utilizados na industria textil ou nas industrias semelhantes;1;KG
4374;38099130;Produtos ignifugos dos tipos utilizados na industria textil ou nas industrias semelhantes;1;KG
4375;38099141;Impermeabilizantes a base de parafina ou de derivados de acidos graxos;1;KG
4376;38099149;Outros impermeabilizantes dos tipos utilizados na industria textil ou nas industrias semelhantes;1;KG
4377;38099190;Outros agentes de apresto/acabamento, etc, para industria textil;1;KG
4378;38099211;Impermeabilizantes dos tipos utilizados na industria do papel ou nas industrias semelhantes, a base de parafina ou de derivados de acidos graxos;1;KG
4379;38099219;Outros impermeabilizantes dos tipos utilizados na industria do papel ou nas industrias semelhantes;1;KG
4380;38099290;Outros agentes de apresto/acabamento, etc, para industria do papel;1;KG
4381;38099311;Impermeabilizantes dos tipos utilizados na industria do couro ou nas industrias semelhantes, a base de parafina ou de derivados de acidos graxos;1;KG
4382;38099319;Outros impermeabilizantes dos tipos utilizados na industria do couro ou nas industrias semelhantes;1;KG
4383;38099390;Outros agentes de apresto/acabamento, etc, para a industria do couro;1;KG
4384;38101010;Preparacoes para decapagem de metais;1;KG
4385;38101020;Pastas e pos para soldar;1;KG
4386;38109000;Outros fluxos/preparacoes auxiliares/varetas, para soldar, etc.;1;KG
4387;38111100;Preparacoes antidetonantes a base de compostos de chumbo;1;KG
4388;38111900;Outras preparacoes antidetonantes;1;KG
4389;38112110;Aditivos para oleos lubrificantes, que contenham oleos de petroleo ou de minerais betuminosos, melhoradores do indice de viscosidade;1;KG
4390;38112120;Aditivos para oleos lubrificantes, que contenham oleos de petroleo ou de minerais betuminosos, antidesgastes, anticorrosivos ou antioxidantes, contendo dialquilditiofosfato de zinco ou diarilditiofosfato de zinco;1;KG
4391;38112130;Aditivos para oleos lubrificantes, que contenham oleos de petroleo ou de minerais betuminosos, dispersantes sem cinzas;1;KG
4392;38112140;Aditivos para oleos lubrificantes, que contenham oleos de petroleo ou de minerais betuminosos, detergentes metalicos;1;KG
4393;38112150;Outras preparacoes contendo, pelo menos, um de quaisquer dos produtos compreendidos nos itens 3811.21.10, 3811.21.20, 3811.21.30 e 3811.21.40;1;KG
4394;38112190;Outs.aditivos cont.oleo de petroleo, etc.p/oleos lubrif.;1;KG
4395;38112910;Outros aditivos dispersantes sem cinzas;1;KG
4396;38112920;Outros aditivos detergentes metalicos;1;KG
4397;38112990;Outros aditivos para oleos lubrificantes;1;KG
4398;38119010;Outros aditivos dispersantes sem cinzas, para oleos de petroleo combustiveis;1;KG
4399;38119090;Outros aditivos preparados, para oleos minerais e outros liquidos;1;KG
4400;38121000;Preparacoes denominadas aceleradores de vulcanizacao;1;KG
4401;38122000;Plastificantes compostos para borracha ou plasticos;1;KG
4402;38123100;Misturas de oligomeros de 2,2,4-trimetil-1,2-diidroquinolina (TMQ);1;KG
4403;38123911;Preparacoes antioxidantes e outros estabilizadores compostos, para borracha, que contenham derivados N-substituidos de p-fenilenodiamina;1;KG
4404;38123912;Preparacoes antioxidantes e outros estabilizadores compostos, para borracha, que contenham fosfitos de alquila, de arila ou de alquil-arila;1;KG
4405;38123919;Preparacoes antioxidantes e outros estabilizadores compostos, para borracha;1;KG
4406;38123921;Preparacoes antioxidantes e outros estabilizadores compostos, para plastico, que contenham derivados N-substituidos de p-fenilenodiamina;1;KG
4407;38123929;Outras preparacoes antioxidantes e outros estabilizadores compostos, para borracha ou plastico;1;KG
4408;38130010;Composicoes e cargas para aparelhos extintores, que contenham bromoclorodifluorometano, bromotrifluorometano ou dibromotetrafluoroetanos;1;KG
4409;38130020;Composicoes e cargas para aparelhos extintores, que contenham hidrobromofluorcarbonetos do metano, do etano ou do propano (HBFC);1;KG
4410;38130030;Composicoes e cargas para aparelhos extintores, que contenham hidroclorofluorcarbonetos do metano, do etano ou do propano (HCFC);1;KG
4411;38130040;Composicoes e cargas para aparelhos extintores, que contenham bromoclorometano;1;KG
4412;38130090;Outras composicoes e cargas para aparelhos extintores, granadas e bombas extintoras;1;KG
4413;38140010;Solventes e diluentes organicos compostos, nao especificados nem compreendidos noutras posicoes, preparacoes concebidas para remover tintas ou vernizes, que contenham clorofluorcarbonetos do metano, do etano ou do propano (CFC), mesmo que contenham HCFC;1;KG
4414;38140020;Solventes e diluentes organicos compostos, nao especificados nem compreendidos noutras posicoes, preparacoes concebidas para remover tintas ou vernizes, que contenham HCFC, mas que nao contenham CFC;1;KG
4415;38140030;Solventes e diluentes organicos compostos, nao especificados nem compreendidos noutras posicoes, preparacoes concebidas para remover tintas ou vernizes, que contenham tetracloreto de carbono, bromoclorometano ou 1,1,1-tricloroetano (metilcloroformio);1;KG
4416;38140090;Outros solventes e diluentes organicos compostos, etc.;1;KG
4417;38151100;Catalisadores em suporte, tendo como substancia ativa o niquel ou um composto de niquel;1;KG
4418;38151210;Catalisadores em suporte, tendo como substancia ativa um metal precioso ou um composto de metal precioso, em colmeia ceramica ou metalica para conversao catalitica de gases de escape de veiculos;1;KG
4419;38151220;Catalisadores em suporte, tendo como substancia ativa um metal precioso ou um composto de metal precioso, com tamanho de particula inferior a 500 micrometros (microns);1;KG
4420;38151290;Outros catalisadores, tendo substancia ativa metal precioso;1;KG
4421;38151900;Outros catalizadores em suporte;1;KG
4422;38159010;Outras preparacoes cataliticas para craqueamento de petroleo;1;KG
4423;38159091;Outras preparacoes cataliticas, tendo como substancia ativa o isoprenilaluminio (IPRA);1;KG
4424;38159092;Outras preparacoes cataliticas, substancia ativa oxido de zinco;1;KG
4425;38159099;Outras preparacoes cataliticas;1;KG
4426;38160011;Cimento/argamassa, a base de magnesita calcinada, refratrario;1;KG
4427;38160012;Cimento e argamassa, a base de silimanita, refratrarios;1;KG
4428;38160019;Outros cimentos e argamassas, refratrarios;1;KG
4429;38160021;Preparacoes refratarias que contenham grafita e 50 % ou mais, em peso, de corindon;1;KG
4430;38160029;Outras preparacoes a base de cromo-magnesita, etc, refratarias;1;KG
4431;38160090;Outros concretos e composicoes semelhantes, refratrarios;1;KG
4432;38170010;Misturas de alquilbenzenos;1;KG
4433;38170020;Misturas de alquilnaftalenos;1;KG
4434;38180010;Elementos quimicos impurificados (dopados), proprios para utilizacao em eletronica, em forma de discos, plaquetas (wafers), ou formas analogas, compostos quimicos impurificados (dopados), proprios para utilizacao em eletronica, de silicio;1;KG
4435;38180090;Outros elementos quimicos impurificados (dopados), proprios para utilizacao em eletronica, em forma de discos, plaquetas (wafers), ou formas analogas, compostos quimicos impurificados (dopados), proprios para utilizacao em eletronica;1;KG
4436;38190000;Fluidos para freios hidraulicos e outros liquidos preparados para transmissoes hidraulicas, que nao contenham oleos de petroleo nem de minerais betuminosos, ou que os contenham em proporcao inferior a 70 %, em peso;1;KG
4437;38200000;Preparacoes anticongelantes e liquidos preparados para descongelamento;1;KG
4438;38210000;Meios de cultura preparados para o desenvolvimento e a manutencao de microrganismos (incluindo os virus e os organismos similares) ou de celulas vegetais, humanas ou animais;1;KG
4439;38220010;Reagentes para determinacao de componentes do sangue ou da urina, sobre suporte de papel, em rolos, sem suporte adicional hidrofobo, improprios para uso direto;1;KG
4440;38220090;Outros reagentes de diagnostico ou de laboratorio;1;KG
4441;38231100;Acido estearico (acido graxo monocarboxilico industrial);1;KG
4442;38231200;Acido oleico (acido graxo monocarboxilico industrial);1;KG
4443;38231300;Acido graxo (gordo) do tall oil;1;KG
4444;38231900;Outros acidos graxos monocarboxilicos industriais e oleos acidos de refinacao;1;KG
4445;38237010;Alcool estearico (alcool graxo industrial);1;KG
4446;38237020;Alcool laurico (alcool graxo industrial);1;KG
4447;38237030;Outras misturas de alcoois primarios alifaticos;1;KG
4448;38237090;Outros alcoois graxos industriais;1;KG
4449;38241000;Aglutinantes preparados para moldes ou para nucleos de fundicao;1;KG
4450;38243000;Carbonetos metalicos nao aglomerados, misturados entre si ou com aglutinantes metalicos;1;KG
4451;38244000;Aditivos preparados para cimentos, argamassas ou concretos;1;KG
4452;38245000;Argamassas e concretos, nao refratarios;1;KG
4453;38246000;Sorbitol, exceto o da subposicao 2905.44 (polialcool d-glucitol);1;KG
4454;38247110;Misturas que contenham triclorotrifluoroetanos;1;KG
4455;38247190;Outras misturas contendo hidrocarboneto aciclico peralogenado com fluor e cloro;1;KG
4456;38247200;Outras misturas que contenham bromoclorodifluorometano, bromotrifluorometano ou dibromotetrafluoroetanos;1;KG
4457;38247300;Outras misturas que contenham hidrobromofluorcarbonetos (HBFC);1;KG
4458;38247410;Preparacoes que contenham clorodifluormetano e pentafluoretano;1;KG
4459;38247420;Preparacoes que contenham clorodifluormetano e clorotetrafluoretano;1;KG
4460;38247490;Outros produtos preparados a base de compostos organicos;1;KG
4461;38247500;Misturas que contenham tetracloreto de carbono;1;KG
4462;38247600;Misturas que contenham 1,1,1-tricloroetano (metilcloroformio);1;KG
4463;38247700;Misturas que contenham bromometano (brometo de metila) ou bromoclorometano;1;KG
4464;38247810;Preparacoes que contenham tetrafluoretano e pentafluoretano;1;KG
4465;38247890;Outros produtos e preparacoes a base de compostos organicos;1;KG
4466;38247900;Outras misturas com derivados peralogenados, etc;1;KG
4467;38248110;Mistura de oxido de propileno com um conteudo de oxido de etileno inferior ou igual a 30 %, em peso;1;KG
4468;38248190;Outros produtos e preparacoes a base de compostos organicos;1;KG
4469;38248200;Misturas que contenham polibromobifenilas (PBB), policloroterfenilas (PCT) ou policlorobifenilas (PCB);1;KG
4470;38248300;Misturas que contenham fosfato de tris(2,3-dibromopropila);1;KG
4471;38248400;Mercadorias mencionadas na Nota de subposicoes 3 do presente Capitulo, que contenham aldrin, canfecloro, clordano, clordecona , DDT, 1,1,1-tricloro-2,2-bis(p-clorofenil)etano), dieldrin, endossulfan, endrin, heptacloro ou mirex;1;KG
4472;38248500;Mercadorias mencionadas na Nota de subposicoes 3 do presente Capitulo, que contenham 1,2,3,4,5,6-hexaclorocicloexano (HCH (ISO)), incluindo o lindano (ISO, DCI);1;KG
4473;38248600;Mercadorias mencionadas na Nota de subposicoes 3 do presente Capitulo, que contenham pentaclorobenzeno (ISO) ou hexaclorobenzeno (ISO);1;KG
4474;38248700;Mercadorias mencionadas na Nota de subposicoes 3 do presente Capitulo, que contenham acido perfluoroctano sulfonico, seus sais, perfluoroctanossulfonamidas, ou fluoreto de perfluoroctanossulfonila;1;KG
4475;38248800;Mercadorias mencionadas na Nota de subposicoes 3 do presente Capitulo, que contenham eteres tetra-, penta-, hexa-, hepta- ou octabromodifenilicos;1;KG
4476;38249100;Misturas e preparacoes constituidas principalmente por metilfosfonato de (5-etil-2-metil-2-oxido-1,3,2-dioxafosfinan-5-il)metil metila e metilfosfonato de bis[(5-etil-2-metil-2-oxido-1,3,2-dioxafosfinan-5-il)metila];1;KG
4477;38249911;Salinomicina micelial;1;KG
4478;38249912;Produtos intermediarios da fabricacao de antibioticos ou de vitaminas ou de outros produtos da posicao 29.36, com um teor de cianocobalamina inferior ou igual a 55�%, em peso;1;KG
4479;38249913;Produtos intermediarios da fabricacao de antibioticos ou de vitaminas ou de outros produtos da posicao 29.36, da fabricacao da primicina amonica;1;KG
4480;38249914;Senduramicina sodica, da fabricacao da senduramicina;1;KG
4481;38249915;Maduramicina amonica, em solucao alcoolica, da fabricacao da maduramicina;1;KG
4482;38249919;Outros produtos intermediarios da fabricacao de antibioticos ou de vitaminas ou de outros produtos da posicao 29.36;1;KG
4483;38249921;Acidos graxos dimerizados, preparacoes contendo acidos graxos dimerizados;1;KG
4484;38249922;Preparacoes contendo estearoilbenzoilmetano e palmitoilbenzoilmetano, preparacoes contendo caprilato e caprato de propilenoglicol;1;KG
4485;38249923;Preparacoes contendo trigliceridios dos acidos caprilico e caprico;1;KG
4486;38249924;Esteres de alcoois graxos de C12 a C20 do acido metacrilico e suas misturas, esteres de acidos monocarboxilicos de C10 ramificados com glicerol;1;KG
4487;38249925;Misturas de esteres dimetilicos dos acidos adipico, glutarico e succinico, misturas de acidos dibasicos de C11 e C12, acidos naftenicos, seus sais insoluveis em agua e seus esteres;1;KG
4488;38249929;Outros derivados de acidos graxos industriais, outras misturas e preparacoes contendo alcoois graxos ou acidos carboxilicos ou derivados destes produtos;1;KG
4489;38249931;Misturas e preparacoes para borracha ou plastico e outras misturas e preparacoes para endurecer resinas sinteticas, colas, pinturas ou usos similares, que contenham isocianatos de hexametileno ou outros isocianatos;1;KG
4490;38249932;Misturas e preparacoes para borracha ou plastico e outras misturas e preparacoes para endurecer resinas sinteticas, colas, pinturas ou usos similares, que contenham aminas graxas de C8 a C22;1;KG
4491;38249933;Misturas e preparacoes para borracha ou plastico e outras misturas e preparacoes para endurecer resinas sinteticas, colas, pinturas ou usos similares, que contenham polietilenoaminas e dietilenotriaminas, proprias para a coagulacao do latex;1;KG
4492;38249934;Outras misturas contendo polietilenoaminas;1;KG
4493;38249935;Misturas de mono-, di- e triisopropanolaminas;1;KG
4494;38249936;Reticulantes para silicones;1;KG
4495;38249939;Outras misturas e preparacoes para borracha ou plastico e outras misturas e preparacoes para endurecer resinas sinteticas, colas, pinturas ou usos similares;1;KG
4496;38249941;Preparacoes desincrustantes, anticorrosivas ou antioxidantes;1;KG
4497;38249942;Mistura eutetica de difenila e oxido de difenila;1;KG
4498;38249943;Misturas a base de trimetil-3,9-dietildecano;1;KG
4499;38249949;Outras misturas e preparacoes desincrustantes, anticorrosivas ou antioxidantes, fluidos para a transferencia de calor;1;KG
4500;38249951;Antiespumantes contendo fosfato de tributila em solucao de alcool isopropilico;1;KG
4501;38249952;Misturas de polietilenoglicois;1;KG
4502;38249953;Polipropilenoglicol liquido;1;KG
4503;38249954;Retardante de chama contendo misturas de trifenilfosfatos isopropilados;1;KG
4504;38249959;Misturas e preparacoes contendo esteres de acidos inorganicos e seus derivados;1;KG
4505;38249971;Cal sodada, carbonato de calcio hidrofugo;1;KG
4506;38249972;Preparacoes a base de silica em suspensao coloidal, nitreto de boro de estrutura cristalina cubica, compactado com substrato de carbeto de tungstenio (volframio);1;KG
4507;38249973;Preparacoes a base de carbeto de tungstenio (volframio) com niquel como aglomerante, brometo de hidrogenio em solucao;1;KG
4508;38249974;Preparacoes a base de hidroxido de niquel ou de cadmio, de oxido de cadmio ou de oxido ferroso ferrico, proprios para a fabricacao de acumuladores alcalinos;1;KG
4509;38249975;Preparacoes utilizadas na elaboracao de meios de cultura, trocadores de ions para o tratamento de aguas, preparacoes a base de zeolitas artificiais;1;KG
4510;38249976;Compostos absorventes a base de metais para aperfeicoar o vacuo nos tubos ou valvulas eletricas;1;KG
4511;38249977;Adubos (fertilizantes) foliares contendo zinco ou manganes;1;KG
4512;38249978;Preparacoes a base de oxido de aluminio e oxido de zirconio, com um conteudo de oxido de zirconio igual ou superior a 20 %, em peso;1;KG
4513;38249979;Outros produtos e preparacoes a base de elementos quimicos ou de seus compostos inorganicos, nao especificados nem compreendidos noutras posicoes;1;KG
4514;38249981;Preparacoes a base de anidrido poliisobutenilsuccinico, em oleo mineral;1;KG
4515;38249982;Halquinol, tetraclorohidroxiglicina de aluminio e zirconio;1;KG
4516;38249983;Triisocianato de tiofosfato de fenila ou de trifenilmetano, em solucao de cloreto de metileno ou de acetato de etila, preparacoes a base de tetraacetiletilenodiamina (TAED), em granulos;1;KG
4517;38249985;Metilato de sodio em metanol;1;KG
4518;38249986;Maneb, mancozeb, cloreto de benzalconio;1;KG
4519;38249987;Dispersao aquosa de microcapsulas de poliuretano ou de melamina-formaldeido contendo um precursor de corante em solventes organicos;1;KG
4520;38249988;Misturas constituidas principalmente pelos compostos seguintes: alquilfosfonofluoridatos de O-alquila (de ate C10, incluindo os cicloalquilas), N,N-dialquilfosforoamidocianidatos de O-alquila (de ate C10, incluindo os cicloalquilas), hidrogenio alquilfosf;1;KG
4521;38249989;Outros produtos e preparacoes a base de compostos organicos, nao especificados nem compreendidos noutras posicoes;1;KG
4522;38251000;Lixos municipais;1;KG
4523;38252000;Lamas de tratamento de esgotos;1;KG
4524;38253000;Residuos clinicos;1;UN
4525;38254100;Residuos de solventes organicos, halogenados;1;KG
4526;38254900;Outros residuos de solventes organicos;1;KG
4527;38255000;Residuos de solucoes decapantes para metais, de fluidos hidraulicos, de fluidos para freios e de fluidos anticongelantes;1;KG
4528;38256100;Residuos das industrias quimicas contendo constituinte organico;1;KG
4529;38256900;Outros residuos das industrias quimicas/conexas;1;KG
4530;38259000;Outros produtos residuais das industrias quimicas, etc.;1;KG
4531;38260000;Biodiesel e suas misturas, que nao contenham ou que contenham menos de 70 %, em peso, de oleos de petroleo ou de oleos minerais betuminosos;1;M3
4532;39011010;Polietileno linear, densidade < 0.94, em forma primaria;1;KG
4533;39011091;Polietileno com carga, densidade < 0.94, em forma primaria;1;KG
4534;39011092;Polietileno sem carga, densidade < 0.94, em forma primaria;1;KG
4535;39012011;Polietileno com carga, vulcanizado, densidade > 1.3, em forma primaria;1;KG
4536;39012019;Outros polietilenos com carga, densidade >= 0.94, em formas primarias;1;KG
4537;39012021;Polietileno sem carga, vulcanizado, densidade > 1.3, em forma primaria;1;KG
4538;39012029;Outros polietilenos sem carga, densidade >= 0.94, em formas primarias;1;KG
4539;39013010;Copolimeros de etileno e acetato de vinila, nas formas previstas na Nota 6 a) deste Capitulo, em formas primarias;1;KG
4540;39013090;Outros copolimeros de etileno e acetato de vinila, em formas primarias;1;KG
4541;39014000;Copolimeros de etileno e alfa-olefina, de densidade inferior a 0,94;1;KG
4542;39019010;Copolimeros de etileno e acido acrilico, em formas primarias;1;KG
4543;39019020;Copolimeros de etileno e monomeros com radicais carboxilicos, inclusive com metacrilato de metila ou acrilato de metila como terceiro monomero;1;KG
4544;39019030;Polietileno clorossulfonado, em forma primaria;1;KG
4545;39019040;Polietileno clorado, em forma primaria;1;KG
4546;39019050;Copolimeros de etileno - acido metacrilico, com um conteudo de etileno superior ou igual a 60 %, em peso;1;KG
4547;39019090;Outros polimeros de etileno, em formas primarias;1;KG
4548;39021010;Polipropileno com carga, em forma primaria;1;KG
4549;39021020;Polipropileno sem carga, em forma primaria;1;KG
4550;39022000;Poliisobutileno em forma primaria;1;KG
4551;39023000;Copolimeros de propileno, em formas primarias;1;KG
4552;39029000;Outros polimeros de propileno ou de outras olefinas, em formas primarias;1;KG
4553;39031110;Poliestireno expansivel, com carga, em forma primaria;1;KG
4554;39031120;Poliestireno expansivel, sem carga, em forma primaria;1;KG
4555;39031900;Outros poliestirenos em formas primarias;1;KG
4556;39032000;Copolimeros de estireno-acrilonitrila (SAN), em formas primarias;1;KG
4557;39033010;Copolimeros de acrilonitrila-butadieno-estireno (ABS), com carga;1;KG
4558;39033020;Copolimeros de acrilonitrila-butadieno-estireno (ABS), sem carga;1;KG
4559;39039010;Copolimeros de metacrilato de metilbutadieno-estireno (MBS);1;KG
4560;39039020;Copolimeros de acrilonitrilo-estireno-acrilato de butilo (ASA);1;KG
4561;39039090;Outros polimeros de estireno, em formas primarias;1;KG
4562;39041010;Poli(cloreto de vinila), nao misturado com outras substancias, obtido por processo de suspensao;1;KG
4563;39041020;Poli(cloreto de vinila), nao misturado com outras substancias, obtido por processo de emulsao;1;KG
4564;39041090;Outros policloretos de vinila, em formas primarias;1;KG
4565;39042100;Policloreto de vinila, nao plastificado, em forma primaria;1;KG
4566;39042200;Policloreto de vinila, plastificado, em forma primaria;1;KG
4567;39043000;Copolimeros de cloreto, acetato de vinila, formas primarias;1;KG
4568;39044010;Outros copolimeros de cloreto de vinila, com acetato de vinila, com um acido dibasico ou com alcool vinilico, nas formas previstas na Nota 6 b) deste Capitulo;1;KG
4569;39044090;Outros copolimeros de cloreto de vinila, formas primarias;1;KG
4570;39045010;Copolimeros de cloreto de vinilideno, sem emulsionante nem plastificante;1;KG
4571;39045090;Outros polimeros de cloreto vinilideno, formas primarias;1;KG
4572;39046110;Politetrafluoretileno nas formas previstas na Nota 6 a) deste Capitulo;1;KG
4573;39046190;Outros politetrafluoretilenos em formas primarias;1;KG
4574;39046910;Copolimero de fluoreto de vinilideno e hexafluorpropileno;1;KG
4575;39046990;Outros polimeros fluorados, em formas primarias;1;KG
4576;39049000;Outros polimeros de cloreto de vinila ou de outras olefinas halogenadas, em formas primarias;1;KG
4577;39051200;Acetato de polivinila, em dispersao aquosa;1;KG
4578;39051910;Acetato de polivinila, com alcool vinilico, em blocos, etc;1;KG
4579;39051990;Outros polimeros de acetato de polivinila, formas primarias;1;KG
4580;39052100;Copolimeros de acetato de vinila, em dispersao aquosa;1;KG
4581;39052900;Outros copolimeros de acetato de vinila, formas primarias;1;KG
4582;39053000;Alcool polivinilico, em forma primaria;1;KG
4583;39059130;Copolimero de vinilpirrolidona e acetato de vinila, em solucao alcoolica;1;KG
4584;39059190;Outros copolimeros de acetato de vinila, etc.formas prim;1;KG
4585;39059910;Poli (vinilformal);1;KG
4586;39059920;Poli (butiral de vinila);1;KG
4587;39059930;Poli (vinilpirrolidona) iodada;1;KG
4588;39059990;Outros polimeros de vinila, em formas primarias;1;KG
4589;39061000;Polimetacrilato de metila, em forma primaria;1;KG
4590;39069011;Acido poliacrilico e sais, em liquido/pasta, soluvel em agua;1;KG
4591;39069012;Sal sodico do poli(acido acrilamidico), soluvel em agua;1;KG
4592;39069019;Outros polimeros acrilicos, em liquidos e pastas, soluveis em agua;1;KG
4593;39069021;Poli(acido acrilico) e seus sais;1;KG
4594;39069022;Copolimero de metacrilato de 2-diisopropilaminoetila e metacrilato de n-decila, em suspensao de dimetilacetamida;1;KG
4595;39069029;Outros polimeros acrilicos, em liquido/pasta, em solvente organico;1;KG
4596;39069031;Poli(acido acrilico) e seus sais, em liquido e pasta, etc;1;KG
4597;39069032;Sal sodico do poli(acido acrilamidico), soluvel em agua;1;KG
4598;39069039;Outros polimeros acrilicos, em liquido e pastas, em outros solventes, etc.;1;KG
4599;39069041;Poli(acido acrilico) e seus sais, em blocos irregulares, pedacos, pos, etc;1;KG
4600;39069042;Sal sodico do poli(acido acrilamidico), soluvel em agua, em blocos irregulares, pedacos, pos, etc;1;KG
4601;39069043;Carboxipolimetileno, em po;1;KG
4602;39069044;Poli(acrilato de sodio), com capacidade de absorcao de uma solucao aquosa de cloreto de sodio 0,9 %, em peso, superior ou igual a vinte vezes seu proprio peso, em blocos irregulares, pedacos, pos, etc;1;KG
4603;39069045;Copolimero de poli(acrilato de potassio) e poli(acrilamida), com capacidade de absorcao de agua destilada de ate quatrocentas vezes seu proprio peso, em blocos irregulares, pedacos, pos, etc;1;KG
4604;39069046;Copolimeros de acrilato de metila-etileno com um conteudo de acrilato de metila superior ou igual a 50 %, em peso, em blocos irregulares, pedacos, pos, etc;1;KG
4605;39069047;Copolimero de acrilato de etila, acrilato de n-butila e acrilato de 2-metoxietila, em blocos irregulares, pedacos, pos, etc;1;KG
4606;39069049;Outros polimeros acrilicos, em blocos irregulares, pedacos, pos, etc;1;KG
4607;39071010;Poliacetais, com carga, nas formas previstas na Nota 6 a) deste Capitulo (em liquidos e pastas);1;KG
4608;39071020;Poliacetais, com carga, nas formas previstas na Nota 6 a) deste Capitulo (em outras formas primarias);1;KG
4609;39071031;Polidextrose, sem carga, em liquidos e pastas, etc, nao estabilizados, em formas primarias;1;KG
4610;39071039;Outros poliacetais sem carga, em liquido e pastas, em formas primarias;1;KG
4611;39071041;Polidextrose, sem carga, em blocos irregulares, pedacos, pos, etc, nao estabilizados, em formas primarias;1;KG
4612;39071042;Outros poliacetais sem carga, em po que passe atraves de uma peneira com abertura de malha de 0,85 mm em proporcao superior a 80 %, em peso;1;KG
4613;39071049;Poliacetais sem carga, em outras formas primarias;1;KG
4614;39071091;Outros poliacetais, em granulos, com diametro de particula superior a 2 mm, segundo a Norma ASTM E 11-70;1;KG
4615;39071099;Outros poliacetais;1;KG
4616;39072011;Poli(oxido de fenileno), mesmo modificado com estireno ou estireno-acrilonitrila, com carga, em forma primaria;1;KG
4617;39072012;Poli(oxido de fenileno), mesmo modificado com estireno ou estireno-acrilonitrila, sem carga, em forma primaria;1;KG
4618;39072020;Politetrametilenoeterglicol, em forma primaria;1;KG
4619;39072031;Polietileno glicol 400, em forma primaria;1;KG
4620;39072039;Outros polieterpoliois, em formas primarias;1;KG
4621;39072041;Poli(epicloridrina);1;KG
4622;39072042;Copolimeros de oxido de etileno;1;KG
4623;39072049;Outros;1;KG
4624;39072090;Outros polieteres em formas primarias;1;KG
4625;39073011;Resinas epoxidas com carga, em liquidos e pastas;1;KG
4626;39073019;Resinas epoxidas com carga, em outras formas primarias;1;KG
4627;39073021;Copolimero de tetrabromobisfenol A e epicloridrina (resina epoxida bromada);1;KG
4628;39073022;Resinas epoxidas sem carga, em liquido e pastas;1;KG
4629;39073029;Outras resinas epoxidas sem carga, em formas primarias;1;KG
4630;39074010;Policarbonatos, nas formas previstas na Nota 6 b) deste Capitulo,com transmissao de luz de comprimento de onda de 550 nm ou 800 nm, > 89 %, segundo Norma ASTM D 1003-00 e indice de fluidez de massa >= 60 g/10 min e <= 80 g/10 min segundo Norma ASTM D 1238;1;KG
4631;39074090;Outros policarbonatos em formas primarias;1;KG
4632;39075010;Resinas alquidicas em liquidos e pastas;1;KG
4633;39075090;Resinas alquidicas em outras formas primarias;1;KG
4634;39076100;Poli(tereftalato de etileno), de um indice de viscosidade de 78 ml/g ou mais;1;KG
4635;39076900;Outros poli(tereftalato de etileno);1;KG
4636;39077000;Poli(acido lactico) formas primarias;1;KG
4637;39079100;Outros polieteres nao saturados, em formas primarias;1;KG
4638;39079911;Tereftalato polibutileno com carga fibra vidro, forma primaria;1;KG
4639;39079912;Poli(tereftalato de butileno) em liquido e pastas;1;KG
4640;39079919;Tereftalato de polibutileno em outras formas primarias;1;KG
4641;39079991;Outros poliesteres em liquidos e pastas;1;KG
4642;39079992;Poli (epsilon caprolactona);1;KG
4643;39079999;Outros poliesteres em formas primarias;1;KG
4644;39081011;Poliamida-11 em liquidos e pastas;1;KG
4645;39081012;Poliamida-12 em liquidos e pastas;1;KG
4646;39081013;Poliamida-6 ou poliamida-6, 6, com carga, em liquidos, pastas;1;KG
4647;39081014;Poliamida-6 ou poliamida-6, 6, sem carga, em liquidos, pastas;1;KG
4648;39081019;Poliamidas-6, 9 ou 6, 10 ou 6-12, em liquidos e pastas;1;KG
4649;39081021;Poliamida-11, em blocos irregulares, pedacos, grumos, etc.;1;KG
4650;39081022;Poliamida-12 em blocos irregulares, pedacos, grumos, etc.;1;KG
4651;39081023;Poliamida-6 ou poliamida-6, 6, com carga, em blocos irregulares, pedacos, etc.;1;KG
4652;39081024;Poliamida-6 ou poliamida-6, 6, sem carga, em blocos irregulares, pedacos, etc.;1;KG
4653;39081029;Poliamidas-6, 9 ou 6, 10 ou 6-12, em blocos irregulares, pedacos, grumos, etc.;1;KG
4654;39089010;Copolimero de lauril-lactama, em forma primaria;1;KG
4655;39089020;Outras poliamidas obtidas por condensacao de acidos graxos dimerizados ou trimerizados com etilenaminas;1;KG
4656;39089090;Outras poliamidas em formas primarias;1;KG
4657;39091000;Resinas ureicas, resinas de tioureia, em formas primarias;1;KG
4658;39092011;Melamina-formaldeido, com carga, em po;1;KG
4659;39092019;Outras resinas melaminicas, com carga, em formas primarias;1;KG
4660;39092021;Melamina-formaldeido, sem carga, em po;1;KG
4661;39092029;Outras resinas melaminicas, sem carga, em formas primarias;1;KG
4662;39093100;Poli(isocianato de fenil metileno) (MDI bruto, MDI polimerico);1;KG
4663;39093900;Outras resinas aminicas;1;KG
4664;39094011;Fenol-formaldeido, lipossoluvel, puro ou modificado;1;KG
4665;39094019;Outras resinas fenolicas, lipossoluveis, puras/modificadas;1;KG
4666;39094091;Outros fenois-formaldeidos em formas primarias;1;KG
4667;39094099;Outras resinas fenolicas em formas primarias;1;KG
4668;39095011;Poliuretano em solucoes em solventes organicos;1;KG
4669;39095012;Poliuretano em dispersao aquosa;1;KG
4670;39095019;Outros poliuretanos em liquidos e pastas;1;KG
4671;39095021;Poliuretanos hidroxilados, com propriedades adesivas, em blocos irregulares, pedacos, etc.;1;KG
4672;39095029;Outros poliuretanos em blocos irregulares, pedacos, pos, etc;1;KG
4673;39100011;Misturas de pre-polimeros lineares, etc.(silicone oleo);1;KG
4674;39100012;Polidimetilsiloxano, polimetilidrogenosiloxano ou misturas destes produtos, em dispersao;1;KG
4675;39100013;Copolimeros de dimetilsiloxano com compostos vinilicos, de viscosidade superior ou igual a 1.000.000 cSt;1;KG
4676;39100019;Outros oleos silicones em formas primarias;1;KG
4677;39100021;Elastomeros de silicone, de vulcanizacao a quente;1;KG
4678;39100029;Outros elastomeros de silicone;1;KG
4679;39100030;Resinas (silicone);1;KG
4680;39100090;Silicones em outras formas primarias;1;KG
4681;39111010;Resinas de petroleo, resinas de cumarona, resinas de indeno, resinas de cumarona-indeno e politerpenos, com carga, em formas primarias;1;KG
4682;39111021;Resinas de petroleo, total ou parcialmente hidrogenadas, de Cor Gardner inferior a 3, segundo Norma ASTM D 1544;1;KG
4683;39111029;Outras resinas de petroleo sem carga;1;KG
4684;39119011;Politerpenos modificados quimicamente, exceto com fenois, com carga, em formas primarias;1;KG
4685;39119012;Polieterimidas (PEI) e seus copolimeros, com carga, em formas primarias;1;KG
4686;39119013;Polietersulfonas (PES) e seus copolimeros, com carga, em formas primarias;1;KG
4687;39119014;Poli(sulfeto de fenileno), charge, em formas primarias;1;KG
4688;39119019;Polissulfetos, polissulfonas, etc, com arga, em formas primarias;1;KG
4689;39119021;Politerpenos modificados quimicamente sem carga, em formas primarias;1;KG
4690;39119022;Polissulfeto de fenileno, sem carga, em formas primarias;1;KG
4691;39119023;Polietilenaminas, sem carga, em formas primarias;1;KG
4692;39119024;Polieterimidas (PEI) e seus copolimeros, sem carga, em formas primarias;1;KG
4693;39119025;Polietersulfonas (PES) e seus copolimeros, sem carga, formas primarias;1;KG
4694;39119026;Polissulfonas;1;KG
4695;39119027;Cloreto de hexadimetrina;1;KG
4696;39119029;Outros politerpenos, etc, sem carga, em formas primarias;1;KG
4697;39121110;Acetato de celulose, nao plastificado, com carga, forma primaria;1;KG
4698;39121120;Acetato de celulose, nao plastificado, sem carga, forma primaria;1;KG
4699;39121200;Acetato de celulose, plastificado, em forma primaria;1;KG
4700;39122010;Nitrato de celulose, com carga, em forma primaria;1;KG
4701;39122021;Nitrato de celulose, sem carga, em alcool, teor n/volat>=65%;1;KG
4702;39122029;Outros nitratos de celulose, sem carga, em forma primaria;1;KG
4703;39123111;Carboximetilcelulose com teor> =75%, em formas primarias;1;KG
4704;39123119;Outros carboximetilceluloses em formas primarias;1;KG
4705;39123121;Sais de carboximetilcelulose, teor >= 75%, em formas primarias;1;KG
4706;39123129;Outros sais de carboximetilcelulose, em formas primarias;1;KG
4707;39123910;Metil-, etil- e propilcelulose, hidroxiladas;1;KG
4708;39123920;Outras metilceluloses, em formas primarias;1;KG
4709;39123930;Outras etilceluloses, em formas primarias;1;KG
4710;39123990;Outros eteres de celulose, em formas primarias;1;KG
4711;39129010;Propionato de celulose, em forma primaria;1;KG
4712;39129020;Acetobutirato de celulose, em forma primaria;1;KG
4713;39129031;Celulose microcristalina, em po;1;KG
4714;39129039;Celulose microcristalina, em outras formas primarias;1;KG
4715;39129040;Outras celuloses, em po;1;KG
4716;39129090;Outras celuloses e derivados quimicos, em formas primarias;1;KG
4717;39131000;Acido alginico, seus sais e esteres, em forma primaria;1;KG
4718;39139011;Borracha clorada ou cloridratada, em pedacos, grumos, etc.;1;KG
4719;39139012;Borracha clorada em outras formas primarias;1;KG
4720;39139019;Outros derivados quimicos da borracha natural, em formas primarias;1;KG
4721;39139020;Goma xantana, em formas primarias;1;KG
4722;39139030;Dextrana, em formas primarias;1;KG
4723;39139040;Proteinas endurecidas, em formas primarias;1;KG
4724;39139050;Quitosan, seus sais ou derivados, em formas primarias;1;KG
4725;39139060;Sulfato de condroitina e seus sais;1;KG
4726;39139090;Outros polimeros naturais, inclusive modificados, em formas primarias;1;KG
4727;39140011;Permutadores de ions a base de copolimeros de estireno-divinilbenzeno, sulfonados, em formas primarias;1;KG
4728;39140019;Outros permutadores de ions, a base poliestireno/seus copolimeros;1;KG
4729;39140090;Permutadores de ions, a base de outros polimeros, em formas primarias;1;KG
4730;39151000;Desperdicios, residuos e aparas, de polimeros de etileno;1;KG
4731;39152000;Desperdicios, residuos e aparas, de polimeros de estireno;1;KG
4732;39153000;Desperdicios, residuos e aparas, de polimero de cloreto de vinila;1;KG
4733;39159000;Desperdicios, residuos e aparas, de outros plasticos;1;KG
4734;39161000;Monofilamentos (monofios), etc, de polimeros de etileno;1;KG
4735;39162000;Monofilamentos (monofios), etc, de polimeros de cloreto de vinila;1;KG
4736;39169010;Monofilamentos (monofios), de outros plasticos;1;KG
4737;39169090;Varas, bastoes e perfis, de outros plasticos;1;KG
4738;39171010;Tripas artificiais de proteinas endurecidas;1;KG
4739;39171021;Tripas artificiais fibrosas, de celulose regenerada, de diametro superior ou igual a 150 mm;1;KG
4740;39171029;Tripas artificiais de outros plasticos celulosicos;1;KG
4741;39172100;Tubo rigido, de polimeros de etileno;1;KG
4742;39172200;Tubo rigido, de polimeros de propileno;1;KG
4743;39172300;Tubo rigido, de polimeros de cloreto de vinila;1;KG
4744;39172900;Tubo rigido, de outros plasticos;1;KG
4745;39173100;Tubos flexiveis podendo suportar uma pressao minima de 27,6 Mpa, de plastico;1;KG
4746;39173210;Outros tubos, nao reforcados com outras materias, nem associados de outra forma com outras materias, sem acessorios, de copolimeros de etileno;1;KG
4747;39173221;Tubos capilares, semipermeaveis, proprios para hemodialise ou para oxigenacao sanguinea, de polipropileno;1;KG
4748;39173229;Outros tubos de polipropileno, nao reforcados, sem acessorios;1;KG
4749;39173230;Tubo de tereftalato de polietileno, nao reforcado, sem acessorios;1;KG
4750;39173240;Tubo de silicones, nao reforcado, sem acessorios;1;KG
4751;39173251;Tubos capilares, semipermeaveis, proprios para hemodialise, de celulose regenerada;1;KG
4752;39173259;Outros tubos de celulose regenerada, nao reforcados, sem acessorios;1;KG
4753;39173290;Outros tubos de plasticos, nao reforcados, sem acessorios;1;KG
4754;39173300;Tubo de plastico, nao reforcado, com acessorios;1;KG
4755;39173900;Outros tubos de plasticos;1;KG
4756;39174010;Acessorios para tubos, de plasticos, utilizados em hemodialise;1;KG
4757;39174090;Outros acessorios para tubos, de plasticos;1;KG
4758;39181000;Revestimentos de pavimentos, etc, de polimeros de cloreto vinila;1;KG
4759;39189000;Revestimentos de pavimentos/paredes/tetos, de outros plasticos;1;KG
4760;39191010;Chapas, folhas, tiras, fitas, peliculas e outras formas planas, auto-adesivas, de plasticos, em rolos de largura nao superior a 20 cm, de polipropileno;1;KG
4761;39191020;Chapas, folhas, tiras, fitas, peliculas e outras formas planas, auto-adesivas, de plasticos, em rolos de largura nao superior a 20 cm, de poli(cloreto de vinila);1;KG
4762;39191090;Chapas, folhas, tiras, fitas, peliculas e outras formas planas, auto-adesivas, de plasticos, em rolos de largura nao superior a 20 cm, de outros materiais;1;KG
4763;39199010;Outras chapas, folhas, tiras, fitas, peliculas e outras formas planas, auto-adesivas, de plasticos, mesmo em rolos, de polipropileno;1;KG
4764;39199020;Outras chapas, folhas, tiras, fitas, peliculas e outras formas planas, auto-adesivas, de plasticos, mesmo em rolos, de poli(cloreto de vinila);1;KG
4765;39199090;Outras chapas, folhas, tiras, fitas, peliculas e outras formas planas, auto-adesivas, de plasticos, mesmo em rolos, de outras materias;1;KG
4766;39201010;Chapas de polimeros de etileno, nao reforcadas, sem suporte, de densidade superior ou igual a 0,94, espessura inferior ou igual a 19 micrometros (microns), em rolos de largura inferior ou igual a 66 cm;1;KG
4767;39201091;Chapas de polimero de etileno, de densidade inferior a 0,94, com oleo de parafina e carga (silica e negro-de-carbono), apresentando nervuras paralelas entre si, com uma resistencia eletrica >= 0,030 ohms.cm2 mas inferior ou igual a 0,120 ohms.cm2, etc...;1;KG
4768;39201099;Outras chapas de polimeros de etileno, nao reforcadas nem estratificadas, sem suporte, nem associadas de forma semelhante a outras materias;1;KG
4769;39202011;Chapas, etc, de polimeros de propileno, de densidade inferior a 0,94, com oleo de parafina e carga (silica e negro-de-carbono), apresentando nervuras paralelas entre si, com uma resistencia eletrica superior ou igual a 0,030 ohms.cm2 mas <= 0,120 ohms.cm2;1;KG
4770;39202012;Chapas, etc, de polimeros de propileno, de largura inferior ou igual a 50 cm e espessura inferior ou igual a 25 micrometros (microns), com uma ou ambas as faces rugosas de rugosidade relativa (relacao entre a espessura media e a maxima) >= 6 %, etc...;1;KG
4771;39202019;Outras chapas, etc, de polimero de propileno, biaxialmente orientados, sem suporte;1;KG
4772;39202090;Outras chapas, etc, polimero de propileno, sem suporte, nao reforcada, etc.;1;KG
4773;39203000;Chapas, etc, de polimeros de estireno, sem suporte, nao reforcadas, etc;1;KG
4774;39204310;Chapas de poli(cloreto de vinila), transparentes, termocontrateis, de espessura inferior ou igual a 250 micrometros (microns), que contenham, em peso, pelo menos 6 % de plastificantes;1;KG
4775;39204390;Outras chapas de polimero cloreto de vinila, que contenham, em peso, pelo menos 6 % de plastificantes;1;KG
4776;39204900;Outras chapas, folhas, etc, de polimeros de cloreto vinila;1;KG
4777;39205100;Chapas, etc, de poli(metacrilato de metila), sem suporte, nao reforcada, etc;1;KG
4778;39205900;Outras chapas, etc, de polimeros acrilicos, sem suporte, nao reforcadas;1;KG
4779;39206100;Chapas, etc, de policarbonatos, sem suporte, nao reforcadas, etc;1;KG
4780;39206211;Chapas, etc, de poli(tereftalato de etileno), de espessura inferior a 5 micrometros (microns);1;KG
4781;39206219;Chapas, etc, de poli(tereftalato de etileno), de espessura superior ou igual a 5 micrometros (microns);1;KG
4782;39206291;Chapas, etc, de poli(tereftalato de etileno), com largura superior a 12 cm, sem qualquer trabalho a superficie;1;KG
4783;39206299;Outras chapas, etc, de poli(tereftalato de etileno), sem suporte;1;KG
4784;39206300;Chapas, etc, de poliesteres nao saturados, sem suporte, nao reforcado;1;KG
4785;39206900;Chapas, etc, de outros poliesteres, sem suporte, nao reforcadas, etc;1;KG
4786;39207100;Chapas, etc, de celulose regenerada, sem suporte, nao reforcada, etc;1;KG
4787;39207310;Chapas, etc, de acetatos de celulose, de espessura inferior ou igual a 0,75 mm, sem suporte, nao reforcada;1;KG
4788;39207390;Outras chapas, etc, de acetatos de celulose, nao reforcada;1;KG
4789;39207910;Outras chapas/folhas, de outros derivados da celulose, de fibra vulcanizada, de espessura inferior ou igual a 1 mm;1;KG
4790;39207990;Outras chapas, folhas, tiras, de outros derivados da celulose;1;KG
4791;39209100;Chapas, etc, de poli(butiral de vinila), sem suporte, nao reforcada, etc.;1;KG
4792;39209200;Chapas, etc, de poliamidas, sem suporte, nao reforcadas, etc.;1;KG
4793;39209300;Chapas, etc, de resinas aminicas, sem suporte, nao reforcadas, etc;1;KG
4794;39209400;Chapas, etc, de resinas fenolicas, sem suporte, nao reforcadas, etc.;1;KG
4795;39209910;Chapas, etc, de silicone, sem suporte, nao reforcadas, etc.;1;KG
4796;39209920;Chapas, etc, de poli(alcool vinilico), sem suporte, nao reforcada, etc;1;KG
4797;39209930;Chapas, etc, de polimeros de fluoreto de vinila, sem suporte, nao reforcada, etc.;1;KG
4798;39209940;Chapas, etc, de poliimida, sem suporte, nao reforcadas, etc;1;KG
4799;39209950;Chapas, etc, de poli(clorotrifluoretileno), nao reforcadas, etc;1;KG
4800;39209990;Outras chapas, etc, de outros plasticos, nao alveolar, sem suporte, etc;1;KG
4801;39211100;Outras chapas, folhas, peliculas, tiras e laminas, de plasticos, de polimeros de estireno;1;KG
4802;39211200;Outras chapas, folhas, peliculas, tiras e laminas, de plasticos, de polimeros de cloreto de vinila;1;KG
4803;39211310;Produtos alveolares de poliuretano, com base poliester, de celulas abertas, com um numero de poros por decimetro linear >= a 24 e <= 157 (6 a 40 poros por polegada linear), com resistencia a compressao 50 % (RC50) >= 3,0 kPa e inferior ou igual a 6,0 kPa;1;KG
4804;39211390;Outras chapas, etc, de poliuretanos, alveolares;1;KG
4805;39211400;Outras chapas, folhas, peliculas, tiras e laminas, produtos alveolares, de celulose regenerada;1;KG
4806;39211900;Outras chapas, folhas, peliculas, tiras e laminas, produtos alveolares, de outros plasticos;1;KG
4807;39219011;Outras chapas estratificadas, reforcadas ou com suporte, de resina melamina-formaldeido;1;KG
4808;39219012;Outras chapas estratificadas, reforcadas ou com suporte, de polietileno, com reforco de napas de fibras de polietileno paralelizadas, superpostas entre si em angulo de 90� e impregnadas com resinas;1;KG
4809;39219019;Outras chapas estratificadas, reforcadas ou com suporte;1;KG
4810;39219020;Outras chapas, de poli(tereftalato de etileno), com camada antiestatica a base de gelatina ou de latex em ambas as faces, mesmo com halogenetos de potassio;1;KG
4811;39219090;Outras chapas, folhas, peliculas, tiras, laminas, de plasticos;1;KG
4812;39221000;Banheiras, boxes para chuveiros, pias e lavatorios, de plasticos;1;KG
4813;39222000;Assentos e tampas, de sanitarios, de plasticos;1;KG
4814;39229000;Outros artigos para usos sanitarios ou higienicos, de plasticos;1;KG
4815;39231010;Estojos de plastico, dos tipos utilizados para acondicionar discos para sistemas de leitura por raio laser;1;KG
4816;39231090;Outros artigos semelhantes a caixas, engradados, etc, de plastico;1;KG
4817;39232110;Sacos, bolsas, cartuchos, de polimeros de etileno, de capacidade inferior ou igual a 1.000 cm3;1;KG
4818;39232190;Outros sacos, bolsas e cartuchos, de polimeros de etileno;1;KG
4819;39232910;Sacos, bolsas e cartuchos, de outros plasticos, de capacidade inferior ou igual a 1.000 cm3;1;KG
4820;39232990;Outros sacos, bolsas e cartuchos, de outros plasticos;1;KG
4821;39233000;Garrafoes, garrafas, frascos, artigos semelhantes, de plasticos;1;KG
4822;39234000;Bobinas, carreteis, canelas e suportes semelhantes, de plasticos;1;KG
4823;39235000;Rolhas, tampas, capsulas e outros dispositivos para fechar recipientes, de plastico;1;KG
4824;39239000;Outros artigos de transporte ou de embalagem, de plasticos;1;KG
4825;39241000;Servicos de mesa e outros utensilios de mesa ou de cozinha, de plasticos;1;KG
4826;39249000;Outros artigos de higiene ou de toucador, de plastico;1;KG
4827;39251000;Reservatorios, cisternas, cubas e recipientes analogos, de capacidade superior a 300 litros, de plastico;1;KG
4828;39252000;Portas, janelas e seus caixilhos, alizares e soleiras, de plasticos;1;KG
4829;39253000;Postigos, estores (incluindo as venezianas) e artefatos semelhantes, e suas partes, de plasticos;1;KG
4830;39259010;Artefatos para apetrechamento de construcoes, de plasticos, de poliestireno expandido (EPS);1;KG
4831;39259090;Outros artefatos para apetrechamento de construcoes, de plasticos;1;KG
4832;39261000;Artigos de escritorio e artigos escolares, de plasticos;1;KG
4833;39262000;Vestuario e seus acessorios, de plasticos, inclusive luvas;1;KG
4834;39263000;Guarnicoes para moveis, carrocerias e semelhantes, de plasticos;1;KG
4835;39264000;Estatuetas e outros objetos de ornamentacao, de plasticos;1;KG
4836;39269010;Arruelas (anilhas) de plasticos;1;KG
4837;39269021;Correias de transmissao, de plasticos;1;KG
4838;39269022;Correias transportadoras, de plasticos;1;KG
4839;39269030;Bolsas para uso em medicina (hemodialise e usos semelhantes);1;KG
4840;39269040;Artigos de laboratorio ou de farmacia, de plasticos;1;KG
4841;39269050;Acessorios dos tipos utilizados em linhas de sangue para hemodialise, tais como: obturadores, incluindo os regulaveis (clamps), clipes e similares, de plastico;1;KG
4842;39269061;Aneis de secao transversal circular (O-rings), de tetrafluoretileno e eter perfluormetilvinil, de plastico;1;KG
4843;39269069;Outros aneis de secao transversal circular (O-rings), de plastico;1;KG
4844;39269090;Outras obras de plasticos;1;KG
4845;40011000;Latex de borracha natural, mesmo pre-vulcanizado;1;KG
4846;40012100;Borracha natural em folhas fumadas;1;KG
4847;40012200;Borracha natural tecnicamente especificada (TSNR), em outras formas;1;KG
4848;40012910;Borracha natural crepada;1;KG
4849;40012920;Borracha natural granulada ou prensada;1;KG
4850;40012990;Borracha natural em outras formas;1;KG
4851;40013000;Balata, guta-percha, guaiule, chicle e gomas naturais analogas;1;KG
4852;40021110;Latex de borracha de estireno-butadieno (SBR);1;KG
4853;40021120;Latex de borracha de estireno-butadieno-carboxilada (XSBR);1;KG
4854;40021911;Borracha de estireno-butadieno (SBR), em chapas, folhas, tiras;1;KG
4855;40021912;Borracha de estireno-butadieno (SBR), grau alimenticio de acordo com o estabelecido pelo Food Chemical Codex, em formas primarias;1;KG
4856;40021919;Outras borrachas de estireno-butadieno (SBR);1;KG
4857;40021920;Borracha de estireno-butadieno carboxilada (XSBR), em chapas, etc;1;KG
4858;40022010;Oleo de borracha de butadieno (br);1;KG
4859;40022090;Borracha de butadieno (br), em chapas, folhas, tiras, etc.;1;KG
4860;40023100;Borracha de isobuteno-isopreno (butila) (IIR), em chapas, etc.;1;KG
4861;40023900;Borracha de isobuteno-isopreno halogenada, em chapas, etc;1;KG
4862;40024100;Latex de borracha de cloropreno (clorobutadieno)(CR);1;KG
4863;40024900;Outras borrachas de cloropreno (clorobutadieno), em chapas, etc.;1;KG
4864;40025100;Latex de borracha de acrilonitrila-butadieno (NBR);1;KG
4865;40025900;Borracha de acrilonitrila-butadieno em chapas, folhas, etc.;1;KG
4866;40026000;Borracha de isopreno (ir) em chapas, folhas, tiras, etc.;1;KG
4867;40027000;Borracha de etileno-propileno-dieno nao conjugada (EPDM);1;KG
4868;40028000;Misturas de borracha natural com borracha sintetica, etc;1;KG
4869;40029100;Latex de outras borrachas sinteticas ou artificiais;1;KG
4870;40029910;Borracha estireno-isopreno-estireno em chapas, folhas, etc.;1;KG
4871;40029920;Borracha etileno-propileno-dieno nao conjugado-propileno (EPDM-propileno);1;KG
4872;40029930;Borracha acrilonitrila-butadieno hidrogenada;1;KG
4873;40029990;Outras borrachas sinteticas e artificiais, em chapas, etc;1;KG
4874;40030000;Borracha regenerada, em formas primarias ou em chapas, folhas ou tiras;1;KG
4875;40040000;Desperdicios, residuos e aparas, de borracha nao endurecida, mesmo reduzidos a po ou a granulos;1;KG
4876;40051010;Borracha etileno-propileno-dieno nao conjugado-propileno (EPDM-propileno), com silica e plastificante, em granulos;1;KG
4877;40051090;Outras borrachas vulcanizadas com negro de fumo/silica, em chapas, etc;1;KG
4878;40052000;Borracha misturada, nao vulcanizada, em formas primarias ou em chapas, folhas ou tiras, em solucoes, dispersoes, exceto as da subposicao 4005.10;1;KG
4879;40059110;Preparacoes base para a fabricacao de gomas de mascar, em chapas, folhas e tiras;1;KG
4880;40059190;Outras borrachas misturadas, nao vulcanizadas, em chapas, folhas, tiras;1;KG
4881;40059910;Preparacoes a base de borracha para a fabricacao de gomas de mascar, formas primarias;1;KG
4882;40059990;Outras borrachas misturadas, nao vulcanizadas, em formas primarias;1;KG
4883;40061000;Perfis para recauchutagem, de borracha nao vulcanizada;1;KG
4884;40069000;Outras formas e artigos, de borracha nao vulcanizada;1;KG
4885;40070011;Fios de borracha vulcanizada, recobertos com silicone;1;KG
4886;40070019;Outros fios de borracha vulcanizada;1;KG
4887;40070020;Cordas de borracha vulcanizada;1;KG
4888;40081100;Chapas, folhas e tiras, de borracha vulcanizada nao endurecida, de borracha alveolar;1;KG
4889;40081900;Varetas e perfis, de borracha vulcanizada nao endurecida, de borracha alveolar;1;KG
4890;40082100;Chapas, folhas e tiras, de borracha vulcanizada nao endurecida, de borracha nao alveolar;1;KG
4891;40082900;Varetas e perfis, de borracha vulcanizada nao endurecida, de borracha nao alveolar;1;KG
4892;40091100;Tubo de borracha vulcanizada nao endurecida, nao reforcado, sem acessorios;1;KG
4893;40091210;Tubo de borracha vulcanizada nao endurecida, com acessorios, com uma pressao de ruptura superior ou igual a 17,3 MPa;1;KG
4894;40091290;Outros tubos de borracha vulcanizada nao endurecida, com acessorios;1;KG
4895;40092110;Tubos de borracha vulcanizada nao endurecida, reforcados apenas com metal ou associados de outra forma apenas com metal, sem acessorios, com uma pressao de ruptura superior ou igual a 17,3 MPa;1;KG
4896;40092190;Outros tubos de borracha vulcanizada nao endurecida, reforcados apenas com metal ou associados de outra forma apenas com metal, sem acessorios;1;KG
4897;40092210;Tubos de borracha vulcanizada nao endurecida, reforcados apenas com metal ou associados de outra forma apenas com metal, com acessorios, com uma pressao de ruptura superior ou igual a 17,3 MPa;1;KG
4898;40092290;Outros tubos de borracha vulcanizada nao endurecida, reforcados apenas com metal ou associados de outra forma apenas com metal, com acessorios;1;KG
4899;40093100;Tubos de borracha vulcanizada nao endurecida, reforcados apenas com materias texteis ou associados de outra forma apenas com materias texteis, sem acessorios;1;KG
4900;40093210;Tubos de borracha vulcanizada nao endurecida, reforcados apenas com materias texteis ou associados de outra forma apenas com materias texteis, com acessorios, com uma pressao de ruptura superior ou igual a 17,3 MPa;1;KG
4901;40093290;Outros tubos de borracha vulcanizada nao endurecida, reforcados apenas com materias texteis ou associados de outra forma apenas com materias texteis, com acessorios;1;KG
4902;40094100;Tubos de borracha vulcanizada nao endurecida, reforcados com outras materias ou associados de outra forma com outras materias, sem acessorios;1;KG
4903;40094210;Tubos de borracha vulcanizada nao endurecida, reforcados com outras materias ou associados de outra forma com outras materias, com acessorios, com uma pressao de ruptura superior ou igual a 17,3 MPa;1;KG
4904;40094290;Outros tubos de borracha vulcanizada nao endurecida, reforcados com outras materias ou associados de outra forma com outras materias, com acessorios;1;KG
4905;40101100;Correias transportadoras, de borracha vulcanizada, reforcadas apenas com metal;1;KG
4906;40101200;Correias transportadoras, de borracha vulcanizada, reforcadas apenas com materias texteis;1;KG
4907;40101900;Outras correias transportadoras, de borracha vulcanizada;1;KG
4908;40103100;Correias de transmissao sem fim, de secao trapezoidal, estriadas, com uma circunferencia externa superior a 60 cm, mas nao superior a 180 cm, de borracha vulcanizada;1;KG
4909;40103200;Correias de transmissao sem fim, de secao trapezoidal, nao estriadas, com uma circunferencia externa superior a 60 cm, mas nao superior a 180 cm, de borracha vulcanizada;1;KG
4910;40103300;Correias de transmissao sem fim, de secao trapezoidal, estriadas, com uma circunferencia externa superior a 180 cm, mas nao superior a 240 cm, de borracha vulcanizada;1;KG
4911;40103400;Correias de transmissao sem fim, de secao trapezoidal, nao estriadas, com uma circunferencia externa superior a 180 cm, mas nao superior a 240 cm, de borracha vulcanizada;1;KG
4912;40103500;Correias de transmissao sem fim, sincronas, com uma circunferencia externa superior a 60 cm, mas nao superior a 150 cm, de borracha vulcanizada;1;KG
4913;40103600;Correias de transmissao sem fim, sincronas, com uma circunferencia externa superior a 150 cm, mas nao superior a 198 cm, de borracha vulcanizada;1;KG
4914;40103900;Outras correias de transmissao;1;KG
4915;40111000;Pneumaticos novos, de borracha, dos tipos utilizados em automoveis de passageiros (incluindo os veiculos de uso misto (station wagons) e os automoveis de corrida);1;UN
4916;40112010;Pneumaticos novos, de borracha, dos tipos utilizados em onibus ou caminhoes, de medida 11,00-24;1;UN
4917;40112090;Outros pneumaticos novos, de borracha, dos tipos utilizados em onibus ou caminhoes;1;UN
4918;40113000;Pneumaticos novos, de borracha, dos tipos utilizados em veiculos aereos;1;UN
4919;40114000;Pneumaticos novos, de borracha, dos tipos utilizados em motocicletas;1;UN
4920;40115000;Pneumaticos novos, de borracha, dos tipos utilizados em bicicletas;1;UN
4921;40117010;Pneumaticos novos, de borracha, do tipo utilizado em veiculos e maquinas agricolas ou florestais, nas seguintes medidas: 4,00-15, 4,00-18, 4,00-19, 5,00-15, 5,00-16, 5,50-16, 6,00-16, 6,00-19, 6,00-20, 6,50-16, 6,50-20, 7,50-16, 7,50-18, 7,50-20;1;UN
4922;40117090;Pneumaticos novos, de borracha, do tipo utilizado em veiculos e maquinas agricolas ou florestais, em outras medidas;1;UN
4923;40118010;Pneumaticos novos, de borracha, radiais, para dumpers concebidos para serem utilizados fora de rodovias, com secao de largura igual ou superior a 940 mm (37?), para aros de diametro igual ou superior a 1.448 mm (57?);1;UN
4924;40118020;Pneumaticos novos, de borracha, do tipo utilizado em veiculos e maquinas para a construcao civil, de mineracao e de manutencao industrial, com secao de largura igual ou superior a 1.143 mm (45?), para aros de diametro igual ou superior a 1.143 mm (45?);1;UN
4925;40118090;Outros pneumaticos novos, de borracha, do tipo utilizado em veiculos e maquinas para a construcao civil, de mineracao e de manutencao industrial;1;UN
4926;40119010;Outros pneumaticos novos, de borracha, com secao de largura igual ou superior a 1.143 mm (45?), para aros de diametro igual ou superior a 1.143 mm (45?);1;UN
4927;40119090;Outros pneumaticos novos, de borracha;1;UN
4928;40121100;Pneumaticos recauchutados, dos tipos utilizados em automoveis de passageiros (incluindo os veiculos de uso misto (station wagons) e os automoveis de corrida);1;UN
4929;40121200;Pneumaticos recauchutados, dos tipos utilizados em onibus ou caminhoes;1;UN
4930;40121300;Pneumaticos recauchutados, dos tipos utilizados em veiculos aereos;1;UN
4931;40121900;Outros pneumaticos  recauchutados;1;UN
4932;40122000;Pneumaticos usados de borracha;1;UN
4933;40129010;Flaps para pneus de borracha;1;KG
4934;40129090;Protetores, bandas de rodagem, etc, para pneus de borracha;1;KG
4935;40131010;Camaras de ar de borracha, para pneumaticos do tipo dos utilizados em onibus ou caminhoes, de medida 11,00-24;1;UN
4936;40131090;Outras camaras-de-ar borracha, para pneus de automoveis, etc;1;UN
4937;40132000;Camaras-de-ar de borracha, dos tipos utilizados em bicicletas;1;UN
4938;40139000;Outras camaras-de-ar de borracha;1;UN
4939;40141000;Preservativos de borracha vulcanizada, nao endurecida;1;KG
4940;40149010;Bolsas para gelo ou para agua quente, de borracha vulcanizada nao endurecida, mesmo com partes de borracha endurecida;1;KG
4941;40149090;Outros artigos de higiene ou de farmacia (incluindo as chupetas), de borracha vulcanizada nao endurecida, mesmo com partes de borracha endurecida;1;KG
4942;40151100;Luvas para cirurgia, de borracha vulcanizada, nao endurecida;1;PARES
4943;40151900;Outras luvas de borracha vulcanizada, nao endurecida;1;PARES
4944;40159000;Outros vestuarios e acessorios, de borracha vulcanizada nao endurecida;1;KG
4945;40161010;Partes de veiculos automoveis ou tratores e de maquinas ou aparelhos, nao domesticos, dos Capitulos 84, 85 ou 90, de borracha alveolar vulcanizada nao endurecida;1;KG
4946;40161090;Outras obras de borracha alveolar vulcanizada nao endurecida;1;KG
4947;40169100;Revestimentos para pisos (pavimentos) e capachos, de borracha vulcanizada nao endurecida;1;KG
4948;40169200;Borrachas de apagar;1;KG
4949;40169300;Juntas, gaxetas e semelhantes, de borracha vulcanizada nao endurecida;1;KG
4950;40169400;Defensas, mesmo inflaveis, para atracacao de embarcacoes, de borracha vulcanizada nao endurecida;1;KG
4951;40169510;Artigos inflaveis de salvamento, de borracha vulcanizada nao endurecida;1;KG
4952;40169590;Outros artigos inflaveis, de borracha vulcanizada nao endurecida;1;KG
4953;40169910;Tampoes vedadores para capacitores, de EPDM, com perfuracoes para terminais, de borracha vulcanizada nao endurecida;1;KG
4954;40169990;Outras obras de borracha vulcanizada, nao endurecida;1;KG
4955;40170000;Borracha endurecida (ebonite, por exemplo) sob qualquer forma, incluindo os desperdicios e residuos, obras de borracha endurecida;1;KG
4956;41012000;Couros e peles em bruto, inteiros, nao divididos, de peso unitario nao superior a 8 kg quando secos, a 10 kg quando salgados a seco e a 16 kg quando frescos, salgados a umido ou conservados de outro modo;1;KG
4957;41015010;Couros e peles em bruto, de bovinos, inteiros, de peso unitario superior a 16 kg, sem dividir;1;KG
4958;41015020;Couros e peles em bruto, de bovinos, inteiros, de peso unitario superior a 16 kg, divididos, com o lado flor;1;KG
4959;41015030;Couros e peles em bruto, de bovinos, inteiros, de peso unitario superior a 16 kg, divididos, sem o lado flor;1;KG
4960;41019010;Outros couros e peles, de bovino, incluindo dorsos, meios-dorsos e flancos, divididos, sem dividir;1;KG
4961;41019020;Outros couros e peles, de bovino, incluindo dorsos, meios-dorsos e flancos, divididos, com o lado flor;1;KG
4962;41019030;Outros couros e peles, de bovino, incluindo dorsos, meios-dorsos e flancos, divididos, sem o lado flor;1;KG
4963;41021000;Peles em bruto de ovinos, com la (nao depiladas);1;KG
4964;41022100;Peles em bruto, de ovinos, depiladas ou sem la, piqueladas;1;KG
4965;41022900;Outras peles em bruto, de ovinos, depiladas ou sem la;1;KG
4966;41032000;Peles em bruto, de repteis;1;UN
4967;41033000;Couros e peles, de suinos, em bruto;1;KG
4968;41039000;Peles em bruto, de outros animais;1;KG
4969;41041111;Couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, simplesmente curtidos ao cromo (wet-blue), plena flor, nao divididos, no estado umido;1;M2
4970;41041112;Outros couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, plena flor, nao divididos, no estado umido;1;M2
4971;41041113;Outros couros e peles de bovinos (incluindo os bufalos), com pre-curtimenta vegetal, plena flor, nao divididos;1;M2
4972;41041114;Outros couros e peles de bovinos (incluindo os bufalos), plena flor, nao divididos, no estado umido;1;M2
4973;41041119;Couros de equideos, nao dividido, no estado umido, plena flor, nao divididos, no estado umido;1;M2
4974;41041121;Couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, simplesmente curtidos ao cromo (wet-blue), divididos, com o lado flor, no estado umido;1;M2
4975;41041122;Outros couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, divididos, com o lado flor, no estado umido;1;M2
4976;41041123;Outros couros e peles de bovinos (incluindo os bufalos), com pre-curtimenta vegetal, divididos, com o lado flor, no estado umido;1;M2
4977;41041124;Outros couros e peles de bovinos (incluindo os bufalos), divididos, com o lado flor, no estado umido;1;M2
4978;41041129;Couros de equideos, divididos, com o lado flor, no estado umido;1;M2
4979;41041910;Couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, simplesmente curtidos ao cromo (wet-blue), no estado umido;1;M2
4980;41041920;Outros couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, no estado umido;1;M2
4981;41041930;Outros couros e peles de bovinos (incluindo os bufalos), com pre-curtimenta vegetal, no estado umido;1;M2
4982;41041940;Outros couros e peles de bovinos (incluindo os bufalos), no estado umido;1;M2
4983;41041990;Couros/peles, equideos, umidos;1;M2
4984;41044110;Couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, no estado seco (crust);1;M2
4985;41044120;Outros couros e peles de bovinos (incluindo os bufalos), curtidos ao vegetal, para solas, no estado seco (crust);1;M2
4986;41044130;Outros couros e peles de bovinos (incluindo os bufalos), no estado seco (crust);1;M2
4987;41044190;Couros e peles de equideos, secos, pena flor;1;M2
4988;41044910;Couros e peles inteiros, de bovinos (incluindo os bufalos), de superficie unitaria nao superior a 2,6 m2, no estado seco (crust);1;M2
4989;41044920;Outros couros e peles de bovinos (incluindo os bufalos), no estado seco (crust);1;M2
4990;41044990;Couros/peles equideos, no estado seco (crust);1;M2
4991;41051010;Peles curtidas ou crust de ovinos, depiladas, mesmo divididas, mas nao preparadas de outro modo, no estado umido (incluindo wet-blue), com pre-curtimenta vegetal;1;M2
4992;41051021;Peles curtidas ou crust de ovinos, depiladas, mesmo divididas, mas nao preparadas de outro modo, no estado umido (incluindo wet-blue), pre-curtidas ao cromo (wet-blue);1;M2
4993;41051029;Peles curtidas ou crust de ovinos, depiladas, mesmo divididas, mas nao preparadas de outro modo, no estado umido (incluindo wet-blue), pre-curtidas de outro modo;1;M2
4994;41051090;Outras peles curtidas ou crust de ovinos, depiladas, mesmo divididas, mas nao preparadas de outro modo, no estado umido (incluindo wet-blue);1;M2
4995;41053000;Peles curtidas ou crust de ovinos, depiladas, mesmo divididas, mas nao preparadas de outro modo, no estado seco (crust);1;M2
4996;41062110;Couros e peles, depilados, de caprinos, no estado umido (incluindo wet-blue), com pre-curtimenta vegetal;1;M2
4997;41062121;Couros e peles, depilados, de caprinos, no estado umido (incluindo wet-blue), pre-curtidos ao cromo (wet-blue);1;M2
4998;41062129;Outros couros e peles, depilados, de caprinos, no estado umido (incluindo wet-blue), pre-curtidos de outro modo;1;M2
4999;41062190;Outros couros e peles de caprinos, curtidos;1;M2
5000;41062200;Couros e peles de caprinos, no estado seco crust;1;M2
5001;41063110;Couros e peles de suinos, no estado umido (incluindo wet-blue), simplesmente curtidos ao cromo (wet-blue);1;M2
5002;41063190;Outros couros e peles de suinos, no estado umido (incluindo wet-blue);1;M2
5003;41063200;Couros e peles de suinos, no estado seco (crust);1;M2
5004;41064000;Couros e peles de repteis, curtidos ou crust;1;M2
5005;41069100;Couros e peles de outros animais, curtido, estado umido;1;M2
5006;41069200;Couros e peles de outros animais, no estado seco (crust);1;M2
5007;41071110;Couros e peles inteiros, de bovinos (incluindo os bufalos), plena flor, nao divididos, de superficie unitaria nao superior a 2,6 m2;1;M2
5008;41071120;Outros couros e peles inteiros, de bovinos (incluindo os bufalos), plena flor, nao divididos;1;M2
5009;41071190;Couros e peles inteiros, de equideos, plena flor, nao divididos;1;M2
5010;41071210;Couros e peles inteiros, de bovinos (incluindo os bufalos), divididos, com o lado flor, de superficie unitaria nao superior a 2,6 m2;1;M2
5011;41071220;Outros couros e peles inteiros, de bovinos (incluindo os bufalos), divididos, com o lado flor;1;M2
5012;41071290;Couros e peles, inteiros, de equideos, preparados;1;M2
5013;41071910;Couros e peles de bovinos (incluindo os bufalos), preparados, de superficie unitaria nao superior a 2,6 m2;1;M2
5014;41071920;Outros couros e peles inteiros de bovinos (incluindo os bufalos), preparados;1;M2
5015;41071990;Couros e peles inteiros de equideos, preparados apos curtimenta;1;M2
5016;41079110;Couros e peles, incluindo as tiras, de bovinos (incluindo os bufalos), preparados, plena flor, nao divididos;1;M2
5017;41079190;Couros e peles de equideos, inlcuindo as tiras, preparados, plena flor, nao divididos;1;M2
5018;41079210;Couros e peles, incluindo as tiras, de bovinos (incluindo os bufalos), preparados, divididos, com o lado flor;1;M2
5019;41079290;Couros e peles de equideos, inlcuindo as tiras, preparados, divididos, com o lado flor;1;M2
5020;41079910;Outros couros e peles, de bovinos, preparados;1;M2
5021;41079990;Outros couros e peles de equideos, preparados;1;M2
5022;41120000;Couros preparados apos curtimenta ou apos secagem e couros e peles apergaminhados, de ovinos, depilados, mesmo divididos, exceto os da posicao 41.14;1;M2
5023;41131010;Couros de caprinos, curtidos ao cromo, com acabamento;1;M2
5024;41131090;Outros couros de caprinos, preparados apos curtimenta, etc.;1;M2
5025;41132000;Couros suinos, preparados apos curtimenta, etc.;1;M2
5026;41133000;Couros de repteis, preparados apos curtimento, etc;1;M2
5027;41139000;Couros de outros animais, preparados apos curtimento, etc.;1;M2
5028;41141000;Couros e peles acamurcados (incluindo a camurca combinada);1;M2
5029;41142010;Couros/peles envernizados ou revestidos;1;M2
5030;41142020;Couros/peles metalizados;1;M2
5031;41151000;Couro reconstituido, a base de couro, etc.;1;KG
5032;41152000;Aparas e outros desperdicios de couros, etc.;1;KG
5033;42010010;Artigos de seleiro ou de correeiro, de couro natural ou reconstituido;1;KG
5034;42010090;Artigos de seleiro ou de correeiro, de outras materias;1;KG
5035;42021100;Baus para viagem, malas e maletas, incluindo as de toucador e as maletas e pastas de documentos e para estudantes e artefatos semelhantes, com a superficie exterior de couro natural ou reconstituido;1;UN
5036;42021210;Baus para viagem, malas e maletas, incluindo as de toucador e as maletas e pastas de documentos e para estudantes e artefatos semelhantes, com a superficie exterior de plasticos ou de materias texteis;1;UN
5037;42021220;Malas, maletas e pastas, de materias texteis;1;UN
5038;42021900;Malas, maletas e pastas, de outras materias;1;UN
5039;42022100;Bolsas, mesmo com tiracolo, incluindo as que nao possuam alcas, com a superficie exterior de couro natural ou reconstituido;1;UN
5040;42022210;Bolsas, mesmo com tiracolo, incluindo as que nao possuam alcas, com a superficie exterior de folhas de plasticos;1;UN
5041;42022220;Bolsas, mesmo com tiracolo, incluindo as que nao possuam alcas, com a superficie exterior de materias texteis;1;UN
5042;42022900;Bolsas de outras materias;1;UN
5043;42023100;Artigos do tipo dos normalmente levados nos bolsos ou em bolsas, com a superficie exterior de couro natural ou reconstituido;1;UN
5044;42023200;Artigos do tipo dos normalmente levados nos bolsos ou em bolsas, com a superficie exterior de folhas de plasticos ou de materias texteis;1;KG
5045;42023900;Artigos do tipo dos normalmente levados nos bolsos ou em bolsas, com a superficie exterior de outras materias;1;KG
5046;42029100;Outros artefatos, com a superficie exterior de couro natural ou reconstituido;1;UN
5047;42029200;Outros artefatos, com a superficie exterior de folhas de plasticos ou de materias texteis;1;UN
5048;42029900;Outros artefatos, de outras materias;1;KG
5049;42031000;Vestuario, de couro natural ou reconstituido;1;KG
5050;42032100;Luvas, mitenes e semelhantes, especialmente concebidas para a pratica de esportes, de couro natural ou reconstituido;1;PARES
5051;42032900;Outras luvas, mitenes e semelhantes, de couro natural ou reconstituido;1;PARES
5052;42033000;Cintos, cinturoes e bandoleiras ou talabartes, de couro natural ou reconstituido;1;KG
5053;42034000;Outros acessorios de vestuario, de couro natural ou reconstituido;1;KG
5054;42050000;Outras obras de couro natural ou reconstituido;1;KG
5055;42060000;Obras de tripa, de baudruches, de bexiga ou de tendoes;1;KG
5056;43011000;Peles com pelo em bruto, de visons, inteiras, com ou sem cabeca, cauda ou patas;1;UN
5057;43013000;Peles com pelo em bruto, de cordeiros denominados astraca, breitschwanz, caracul, persianer ou semelhantes, de cordeiros da India, da China, da Mongolia ou do Tibete, inteiras, com ou sem cabeca, cauda ou patas;1;UN
5058;43016000;Peles com pelo em bruto, de raposas, inteiras, com ou sem cabeca, cauda ou patas;1;UN
5059;43018000;Peles com pelo em bruto, de outros animais, inteiras, com ou sem cabeca, cauda ou patas;1;UN
5060;43019000;Cabecas, caudas, patas e outras partes utilizaveis na industria de peles;1;UN
5061;43021100;Peles com pelo inteiras, com ou sem cabeca, cauda ou patas, nao reunidas (nao montadas), de visons;1;UN
5062;43021910;Peles com pelo inteiras, com ou sem cabeca, cauda ou patas, nao reunidas (nao montadas), de ovinos;1;UN
5063;43021990;Outras peles com pelo inteiras, com ou sem cabeca, cauda ou patas, nao reunidas (nao montadas);1;UN
5064;43022000;Cabecas, caudas, patas e outras partes, desperdicios e aparas, nao reunidos (nao montados);1;UN
5065;43023000;Peles com pelo inteiras e respectivos pedacos e aparas, reunidos (montados);1;UN
5066;43031000;Vestuario e seus acessorios, de peles com pelo;1;UN
5067;43039000;Outros artefatos de peles com pelo;1;UN
5068;43040000;Peles com pelo artificiais, e suas obras;1;M2
5069;44011100;Lenha em qualquer forma, de coniferas;1;KG
5070;44011200;Lenha em qualquer forma, de nao coniferas;1;KG
5071;44012100;Madeira em estilhas ou em particulas, de coniferas;1;KG
5072;44012200;Madeira em estilhas ou em particulas, de nao coniferas;1;KG
5073;44013100;Pellets de madeira;1;KG
5074;44013900;Serragem, desperdicios e residuos, de madeira, mesmo aglomerados em toras, briquetes ou em formas semelhantes;1;KG
5075;44014000;Serragem (serradura), desperdicios e residuos, de madeira, nao aglomerados;1;KG
5076;44021000;Carvao vegetal (incluindo o carvao de cascas ou de carocos), mesmo aglomerado, de bambu;1;KG
5077;44029000;Outro carvao vegetal (incluindo o carvao de cascas ou de carocos), mesmo aglomerado;1;KG
5078;44031100;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, tratada com tinta, creosoto ou outros agentes de conservacao, de coniferas;1;M3
5079;44031200;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, tratada com tinta, creosoto ou outros agentes de conservacao, de nao coniferas;1;M3
5080;44032100;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de pinheiro (Pinus spp.), cuja maior dimensao da secao transversal e igual ou superior a 15 cm;1;M3
5081;44032200;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de pinheiro (Pinus spp.);1;M3
5082;44032300;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de abeto (Abies spp.) e de espruce (Picea spp.), cuja maior dimensao da secao transversal e igual ou superior a 15 cm;1;M3
5083;44032400;Madeira de abeto (Abies spp.), e de espruce (Picea spp.) em bruto, mesmo descascada, desalburnada ou esquadriada;1;M3
5084;44032500;Outras madeiras em bruto, mesmo descascada, desalburnada ou esquadriada, de coniferas, cuja maior dimensao da secao transversal e igual ou superior a 15 cm;1;M3
5085;44032600;Outras madeiras em bruto, mesmo descascada, desalburnada ou esquadriada, de coniferas;1;M3
5086;44034100;Madeira Dark Red Meranti, Light Red Meranti e Meranti Bakau, em bruto, mesmo descascada, desalburnada ou esquadriada;1;M3
5087;44034900;Outras madeiras tropicais em bruto, mesmo descascada, desalburnada ou esquadriada;1;M3
5088;44039100;Madeira de carvalho (Quercus spp.), em bruto, mesmo descascada, desalburnada ou esquadriada;1;M3
5089;44039300;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de faia (Fagus spp.), cuja maior dimensao da secao transversal e igual ou superior a 15 cm;1;M3
5090;44039400;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de faia (Fagus spp.), outras;1;M3
5091;44039500;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de betula (vidoeiro) (Betula spp.), cuja maior dimensao da secao transversal e igual ou superior a 15 cm;1;M3
5092;44039600;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de betula (vidoeiro) (Betula spp.), outras;1;M3
5093;44039700;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de choupo (alamo) (Populus spp.);1;M3
5094;44039800;Madeira em bruto, mesmo descascada, desalburnada ou esquadriada, de eucalipto (Eucalyptus spp.);1;M3
5095;44039900;Outras madeiras em bruto, mesmo descascada, desalburnada ou esquadriada;1;M3
5096;44041000;Arcos de madeira, estacas fendidas, estacas agucadas, nao serradas longitudinalmente, madeira simplesmente desbastada ou arredondada, nao torneada, nao recurvada nem trabalhada de qualquer outro modo, para fabricacao de bengalas, etc... de coniferas;1;KG
5097;44042000;Arcos de madeira, estacas fendidas, estacas agucadas, nao serradas longitudinalmente, madeira simplesmente desbastada ou arredondada, nao torneada, nao recurvada nem trabalhada de qualquer outro modo, para fabricacao de bengalas, etc... de nao coniferas;1;KG
5098;44050000;La de madeira, farinha de madeira;1;KG
5099;44061100;Dormentes de madeira para vias ferreas ou semelhantes, nao impregnados, de coniferas;1;M3
5100;44061200;Dormentes de madeira para vias ferreas ou semelhantes, nao impregnados, de nao coniferas;1;M3
5101;44069100;Dormentes de madeira para vias ferreas ou semelhantes, de coniferas;1;M3
5102;44069200;Dormentes de madeira para vias ferreas ou semelhantes, de nao coniferas;1;M3
5103;44071100;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de pinheiro (Pinus spp.);1;M3
5104;44071200;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de abeto (Abies spp.) e de espruce (picea) (Picea spp.);1;M3
5105;44071900;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de outras coniferas;1;M3
5106;44072100;Madeira de mahogany (Mogno) (Swietenia spp.), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5107;44072200;Madeira de virola, imbuia e balsa, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5108;44072500;Madeira de Dark Red Meranti, Light Red Meranti e Meranti Bakau, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5109;44072600;Madeira de White Lauan, White Meranti, White Seraya, Yellow Meranti e Alan, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5110;44072700;Madeira de Sapelli, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5111;44072800;Madeira de Iroko, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5112;44072910;Madeira de cedro, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5113;44072920;Madeira de ipe, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5114;44072930;Madeira de pau-marfim, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5115;44072940;Madeira de louro, serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5116;44072950;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de canafistula (Peltophorum vogelianum);1;M3
5117;44072960;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de cabreuva Parda (Myrocarpus spp.);1;M3
5118;44072970;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de urundei (Astronium balansae);1;M3
5119;44072990;Outras madeiras tropicais serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5120;44079100;Madeira de carvalho (Quercus spp.), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5121;44079200;Madeira de faia (Fagus spp.), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5122;44079300;Madeira de acer (Acer spp.), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5123;44079400;Madeira de cerejeira (Prunus spp.), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5124;44079500;Madeira de freixo (Fraxinus spp.), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5125;44079600;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de betula (vidoeiro) (Betula spp.);1;M3
5126;44079700;Madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm, de choupo (alamo) (Populus spp.);1;M3
5127;44079920;Madeira de peroba (Paratecoma peroba), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5128;44079930;Madeira de guaiuvira (Patagonula americana), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5129;44079960;Madeira de amendoim (Pterogyne nitens), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5130;44079970;Madeira de angico preto (Piptadenia macrocarpa), serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5131;44079990;Outra madeira serrada ou fendida longitudinalmente, cortada transversalmente ou desenrolada, mesmo aplainada, lixada ou unida pelas extremidades, de espessura superior a 6 mm;1;M3
5132;44081010;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de coniferas, obtidas por corte de madeira estratificada;1;M3
5133;44081091;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de pinho brasil (Araucaria angustifolia);1;M3
5134;44081099;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de outras coniferas;1;M3
5135;44083110;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), etc...,  de espessura <= 6 mm, de Dark Red Meranti, Light Red Meranti e Meranti Bakau, obtidas por corte de madeira estratificada;1;M3
5136;44083190;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, Dark Red Meranti, Light Red Meranti e Meranti Bakau;1;M3
5137;44083910;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada),folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., espessura <= 6 mm,obtidas por corte de madeira estratificada, madeiras tropicais;1;M3
5138;44083991;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de cedro;1;M3
5139;44083992;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de pau-marfim;1;M3
5140;44083999;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de outras madeiras tropicais;1;M3
5141;44089010;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada),folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., espessura <= 6 mm,obtidas por corte de madeira estratificada,de outras madeiras;1;M3
5142;44089090;Folhas para folheados (incluindo as obtidas por corte de madeira estratificada), folhas para compensados ou para madeiras estratificadas semelhantes e outras madeiras, etc..., de espessura <= 6 mm, de outras madeiras;1;M3
5143;44091000;Madeira de coniferas perfilada (com espigas, ranhuras, filetes, entalhes, chanfrada, com juntas em V, com cercadura, boleada ou semelhantes) ao longo de uma ou mais bordas, faces ou extremidades, mesmo aplainada, lixada ou unida pelas extremidades;1;M3
5144;44092100;Madeira de bambu perfilada (com espigas, ranhuras, filetes, entalhes, chanfrada, com juntas em V, com cercadura, boleada ou semelhantes) ao longo de uma ou mais bordas, faces ou extremidades, mesmo aplainada, lixada ou unida pelas extremidades;1;M3
5145;44092200;Madeiras tropicais perfilada (com espigas, ranhuras, filetes, entalhes, chanfrada, com juntas em V, com cercadura, boleada ou semelhantes) ao longo de uma ou mais bordas, faces ou extremidades, mesmo aplainada, lixada ou unida pelas extremidades;1;KG
5146;44092900;Outras madeiras de nao coniferas perfilada (com espigas, ranhuras, filetes, entalhes, chanfrada, com juntas em V, com cercadura, boleada ou semelhantes) ao longo de uma ou mais bordas, faces ou extremidades, mesmo aplainada, lixada ou unida pelas extremid;1;KG
5147;44101110;Paineis de particulas de madeira, mesmo aglomeradas com resinas ou com outros aglutinantes organicos, em bruto ou simplesmente polidos;1;M3
5148;44101121;Paineis de particulas de madeira, recobertos na superficie com papel impregnado de melamina, em ambas as faces, com pelicula protetora na face superior e trabalho de encaixe nas quatro laterais, dos tipos utilizados para pisos (pavimentos);1;M3
5149;44101129;Outros paineis de particulas de madeira, recobertos na superficie com papel impregnado de melamina;1;M3
5150;44101190;Outros paineis de particulas de madeira;1;M3
5151;44101210;Paineis denominados oriented strand board (OSB), mesmo aglomeradas com resinas ou com outros aglutinantes organicos, em bruto ou simplesmente polidos;1;M3
5152;44101290;Outros paineis denominados oriented strand board (OSB), mesmo aglomeradas com resinas ou com outros aglutinantes organicos;1;M3
5153;44101911;Paineis denominados waferboard, mesmo aglomeradas com resinas ou com outros aglutinantes organicos, em bruto ou simplesmente polidos;1;M3
5154;44101919;Outros paineis denominados waferboard, mesmo aglomeradas com resinas ou com outros aglutinantes organicos;1;M3
5155;44101991;Outros paineis de madeira em bruto ou simplesmente polidos;1;M3
5156;44101992;Outros paineis de madeiras recobertos na superficie com papel impregnado de melamina;1;M3
5157;44101999;Outros paineis de madeiras;1;M3
5158;44109000;Paineis de outras materias lenhosas;1;M3
5159;44111210;Paineis de fibras madeira de media densidade (denominados MDF), de espessura nao superior a 5 mm, nao trabalhados mecanicamente nem recobertos a superficie;1;M3
5160;44111290;Outros paineis de fibras de madeira de media densidade (denominados MDF), de espessura nao superior a 5 mm;1;M3
5161;44111310;Paineis de fibras madeira de media densidade (denominados MDF), de espessura superior a 5 mm mas nao superior a 9 mm, nao trabalhados mecanicamente nem recobertos a superficie;1;M3
5162;44111391;Outros paineis de fibras madeira denominados MDF, espessura > 5 mm e < 9 mm, recobertos em ambas as faces com papel impregnado de melamina, pelicula protetora na face superior e trabalho de encaixe nas quatro laterais, dos tipos utilizados para pisos;1;M3
5163;44111399;Outros paineis de fibras madeira de media densidade (denominados MDF), de espessura superior a 5 mm mas nao superior a 9 mm;1;M3
5164;44111410;Paineis de fibras madeira de media densidade (denominados MDF), de espessura superior a 9 mm, nao trabalhados mecanicamente nem recobertos a superficie;1;M3
5165;44111490;Outros paineis de fibras madeira de media densidade (denominados MDF), de espessura superior a 9 mm;1;M3
5166;44119210;Paineis de fibras madeira de media densidade (denominados MDF), com densidade superior a 0,8 g/cm3, nao trabalhados mecanicamente nem recobertos a superficie;1;M3
5167;44119290;Outros paineis de fibras madeira de media densidade (denominados MDF), com densidade superior a 0,8 g/cm3;1;M3
5168;44119310;Paineis de fibras madeira de media densidade (denominados MDF), com densidade superior a 0,5 g/cm3 mas nao superior a 0,8 g/cm3, nao trabalhados mecanicamente nem recobertos a superficie;1;M3
5169;44119390;Outros paineis de fibras madeira de media densidade (denominados MDF), com densidade superior a 0,5 g/cm3 mas nao superior a 0,8 g/cm3;1;M3
5170;44119410;Paineis de fibras madeira de media densidade (denominados MDF), com densidade nao superior a 0,5 g/cm3, nao trabalhados mecanicamente nem recobertos a superficie;1;M3
5171;44119490;Outros paineis de fibras madeira de media densidade (denominados MDF), com densidade nao superior a 0,5 g/cm3;1;M3
5172;44121000;Madeira compensada, madeira folheada, e madeiras estratificadas semelhantes, de bambu;1;M3
5173;44123100;Outras madeiras compensadas, constituidas exclusivamente por folhas de madeira (exceto de bambu) cada uma das quais de espessura nao superior a 6 mm, com pelo menos uma face de madeiras tropicais mencionadas na Nota 2 de subposicoes do presente Capitulo;1;M3
5174;44123300;Outras, com, pelo menos, uma camada exterior de madeira nao conifera, das especies amieiro freixo, faia, betula, prunoidea, castanheiro, olmo eucalipto, nogueira, castanheiro-da-india, tilia, bordo, carvalho, platano, choupo,robinia,tulipeiro  ou nogueira;1;M3
5175;44123400;Outras madeiras compensadas com, pelo menos, uma camada exterior de madeira nao conifera, nao especificadas na subposicao 4412.33;1;M3
5176;44123900;Outras madeiras compensadas, constituidas exclusivamente por folhas de madeira (exceto de bambu) cada uma das quais de espessura nao superior a 6 mm;1;M3
5177;44129400;Outra madeira compensada, madeira folheada, e madeiras estratificadas semelhantes, com alma aglomerada, alveolada ou lamelada;1;M3
5178;44129900;Outras madeiras compensadas, folheadas ou estratificadas;1;M3
5179;44130000;Madeira densificada, em blocos, pranchas, laminas ou perfis;1;M3
5180;44140000;Molduras de madeira para quadros, fotografias, espelhos ou objetos semelhantes;1;KG
5181;44151000;Caixotes, caixas, engradados, barricas e embalagens semelhantes, carreteis para cabos, de madeira;1;UN
5182;44152000;Paletes simples, paletes-caixas e outros estrados para carga, taipais de paletes, de madeira;1;UN
5183;44160010;Barris, cubas, balsas, dornas, selhas e outras obras de tanoeiro e respectivas partes de madeira, incluindo as aduelas, de carvalho (Quercus spp.);1;KG
5184;44160090;Barris, cubas, balsas, dornas, selhas e outras obras de tanoeiro e respectivas partes de madeira, incluindo as aduelas, de outras madeiras;1;KG
5185;44170010;Ferramentas de madeira;1;UN
5186;44170020;Formas, alargadeiras e esticadores para calcados, de madeira;1;UN
5187;44170090;Armacoes e cabos, de ferramentas, de escovas e de vassouras, de madeira;1;UN
5188;44181000;Janelas, janelas de sacada e respectivos caixilhos e alizares, de madeira;1;KG
5189;44182000;Portas e respectivos caixilhos, alizares e soleiras, de madeira;1;KG
5190;44184000;Armacoes para concreto, de madeira;1;KG
5191;44185000;Fasquias para telhados (shingles e shakes), de madeira;1;KG
5192;44186000;Postes e vigas de madeira;1;KG
5193;44187300;Paineis montados para revestimento de pisos (pavimentos), de bambu ou com, pelo menos, a camada superior de bambu;1;KG
5194;44187400;Outros paineis montados para revestimento de pisos (pavimentos), para pisos (pavimentos) em mosaico;1;KG
5195;44187500;Outros paineis montados para revestimento de pisos (pavimentos), de camadas multiplas;1;KG
5196;44187900;Outros paineis montados para soalhos;1;KG
5197;44189100;Outras obras de marcenaria e pecas de carpintaria para construcoes, incluindo os paineis celulares, os paineis montados para revestimento de pisos (pavimentos) e as fasquias para telhados (shingles e shakes), de bambu;1;KG
5198;44189900;Outras obras de marcenaria e pecas de carpintaria para construcoes, incluindo os paineis celulares, os paineis montados para revestimento de pisos (pavimentos) e as fasquias para telhados (shingles e shakes);1;KG
5199;44191100;Tabuas para cortar pao, outras tabuas para cortar e artigos semelhantes, de bambu;1;KG
5200;44191200;Pauzinhos (hashi ou fachi), de bambu;1;KG
5201;44191900;Outros artigos de madeira para mesa ou cozinha, de bambu;1;KG
5202;44199000;Outros artigos de madeira para mesa ou cozinha;1;KG
5203;44201000;Estatuetas e outros objetos de ornamentacao, de madeira;1;KG
5204;44209000;Madeira marchetada e madeira incrustada, estojos e guarda-joias para joalheria e ourivesaria, e obras semelhantes, de madeira, artigos de mobiliario, de madeira, que nao se incluam no Capitulo 94;1;KG
5205;44211000;Cabides para vestuario, de madeira;1;KG
5206;44219100;Outras obras em bambu;1;KG
5207;44219900;Outras obras em madeira;1;KG
5208;45011000;Cortica natural, em bruto ou simplesmente preparada;1;KG
5209;45019000;Desperdicios de cortica, cortica triturada, granulada, etc;1;KG
5210;45020000;Cortica natural, sem a crosta ou simplesmente esquadriada, ou em cubos, chapas, folhas ou tiras, de forma quadrada ou retangular (incluindo os esbocos com arestas vivas, para rolhas);1;KG
5211;45031000;Rolhas de cortica natural;1;KG
5212;45039000;Outras obras de cortica natural;1;KG
5213;45041000;Cubos, blocos, chapas, folhas e tiras, ladrilhos de qualquer formato, cilindros macicos, incluindo os discos, de cortica aglomerada;1;KG
5214;45049000;Outras obras de cortica aglomerada;1;KG
5215;46012100;Esteiras, capachos e divisorias, de bambu;1;KG
5216;46012200;Esteiras, capachos e divisorias, de rotim;1;KG
5217;46012900;Esteiras, capachos e divisorias, de outras materias vegetais;1;KG
5218;46019200;Outras materias para entrancar, de bambu;1;KG
5219;46019300;Outras materias para entrancar, de rotim;1;KG
5220;46019400;Outras materias para entrancar de materias vegetais;1;KG
5221;46019900;Trancas/etc, de outras materias, tecidas ou paralelizadas;1;KG
5222;46021100;Obras de cestaria, de bambu;1;KG
5223;46021200;Obras de cestaria, de rotim;1;KG
5224;46021900;Obras de cestaria, de outras materias vegetais;1;KG
5225;46029000;Obras de cestaria, de outras materias para entrancar, etc.;1;KG
5226;47010000;Pastas mecanicas de madeira;1;KG
5227;47020000;Pasta quimica de madeira, para dissolucao;1;KG
5228;47031100;Pastas quimicas de madeira, a soda ou ao sulfato, exceto pastas para dissolucao, cruas, de coniferas;1;KG
5229;47031900;Pastas quimicas de madeira, a soda ou ao sulfato, exceto pastas para dissolucao, cruas, de nao coniferas;1;KG
5230;47032100;Pastas quimicas de madeira, a soda ou ao sulfato, exceto pastas para dissolucao, semibranqueadas ou branqueadas, de coniferas;1;KG
5231;47032900;Pastas quimicas de madeira, a soda ou ao sulfato, exceto pastas para dissolucao, semibranqueadas ou branqueadas, de nao coniferas;1;KG
5232;47041100;Pastas quimicas de madeira, ao bissulfito, exceto pastas para dissolucao, cruas, de coniferas;1;KG
5233;47041900;Pastas quimicas de madeira, ao bissulfito, exceto pastas para dissolucao, cruas, de nao coniferas;1;KG
5234;47042100;Pastas quimicas de madeira, ao bissulfito, exceto pastas para dissolucao, semibranqueadas ou branqueadas, de coniferas;1;KG
5235;47042900;Pastas quimicas de madeira, ao bissulfito, exceto pastas para dissolucao, semibranqueadas ou branqueadas, de nao coniferas;1;KG
5236;47050000;Pastas de madeira obtidas por combinacao de um tratamento mecanico com um tratamento quimico;1;KG
5237;47061000;Pastas de linteres de algodao;1;KG
5238;47062000;Pastas de fibras obtidas a partir de papel ou de cartao reciclados (desperdicios e aparas);1;KG
5239;47063000;Outras pastas de fibras obtidas de bambu;1;KG
5240;47069100;Pastas mecanicas de outras materias fibrosas celulosicas;1;KG
5241;47069200;Pastas quimicas de outras materias fibrosas celulosicas;1;KG
5242;47069300;Pastas semiquimicas de outras materias fibrosas celulosicas;1;KG
5243;47071000;Papeis ou cartoes, Kraft, crus, ou papeis ou cartoes ondulados, para reciclar;1;KG
5244;47072000;Outros papeis ou cartoes, obtidos principalmente a partir de pasta quimica branqueada, nao corada na massa, para reciclar;1;KG
5245;47073000;Papeis ou cartoes, obtidos principalmente a partir de pasta mecanica (por exemplo, jornais, periodicos e impressos semelhantes), praa reciclar;1;KG
5246;47079000;Outros papeis ou cartoes, incluindo os desperdicios e aparas nao selecionados, para reciclar;1;KG
5247;48010020;Papel de jornal, em folhas, mas que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5248;48010030;Outro papel de jornal, em rolos ou em folhas, de peso inferior ou igual a 57 g/m2, em que 65 % ou mais, em peso, do conteudo total de fibras seja constituido por fibras de madeiras obtidas por processo mecanico;1;KG
5249;48010090;Outros papeis de jornal, em rolos ou em folhas;1;KG
5250;48021000;Papel e cartao feitos a mao (folha a folha);1;KG
5251;48022010;Papel e cartao proprios para fabricacao de papeis ou cartoes fotossensiveis, termossensiveis ou eletrossensiveis, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5252;48022090;Outros papeis e cartoes proprios para fabricacao de papeis ou cartoes fotossensiveis, termossensiveis ou eletrossensiveis;1;KG
5253;48024010;Papel proprio para fabricacao de papeis de parede, em tiras ou rolos de largura nao superior a 15 cm;1;KG
5254;48024090;Outros papeis para fabricacao de papeis de parede, em rolos/folhas;1;KG
5255;48025410;Outros papeis e cartoes, de peso inferior a 40 g/m2, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5256;48025491;Papel fabricado principalmente a partir de pasta branqueada ou pasta obtida por um processo mecanico, de peso inferior a 19 g/m2;1;KG
5257;48025499;Outros papeis fabricados obtidos a partir de pasta branqueada, etc;1;KG
5258;48025510;Papel fibra de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em rolos, De largura nao superior a 15 cm;1;KG
5259;48025591;Papel de desenho, sem fibra obtida por processo mecanico, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em rolos;1;KG
5260;48025592;Papel Kraft, sem fibra obtida por processo mecanico, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em rolos;1;KG
5261;48025599;Outros papeis/cartoes sem fibra obtida por processo mecanico, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em rolos;1;KG
5262;48025610;Outros papeis e cartoes,sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %, em peso,do conteudo total de fibras,de peso >= 40 g/m2, mas < 150 g/m2,em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5263;48025691;Papel para impressao de papel-moeda, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em folhas em que um lado nao seja superior a 435 mm e o outro nao seja superior a 297 mm, quando nao dobradas;1;KG
5264;48025692;Papel de desenho, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em folhas em que um lado nao seja superior a 435 mm e o outro nao seja superior a 297 mm, quando nao dobradas;1;KG
5265;48025693;Papel Kraft, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em folhas em que um lado nao seja superior a 435 mm e o outro nao seja superior a 297 mm, quando nao dobradas;1;KG
5266;48025699;Outros papeis, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em folhas em que um lado nao seja superior a 435 mm e o outro nao seja superior a 297 mm, quando nao dobradas;1;KG
5267;48025710;Outros papeis, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2, em tiras de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5268;48025791;Papel para impressao de papel-moeda, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2;1;KG
5269;48025792;Papel de desenho, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2;1;KG
5270;48025793;Papel Kraft, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2;1;KG
5271;48025799;Outros papeis e cartoes, sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras nao seja superior a 10 %, em peso, do conteudo total de fibras, de peso igual ou superior a 40 g/m2, mas nao superior a 150 g/m2;1;KG
5272;48025810;Outros papeis e cartoes,sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %,em peso,do conteudo total de fibras, p > 150 g/m2,em tiras ou rolos l < 15 cm ou em folhas em que nenhum lado > 360 mm...;1;KG
5273;48025891;Papeis e cartoes de desenho, sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %, em peso, do conteudo total de fibras, de peso > 150 g/m2;1;KG
5274;48025892;Papel Kraft, sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %, em peso, do conteudo total de fibras, de peso > 150 g/m2;1;KG
5275;48025899;Outros papeis/cartoes fibra processo mecanico <= 10%, peso > 150 g/m2;1;KG
5276;48026110;Outros papeis e cartoes, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, em rolos, de largura nao superior a 15 cm;1;KG
5277;48026191;Outros papeis e cartoes, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, em rolos, de peso inferior ou igual a 57 g/m2, em que 65 % ou mais, em peso, etc..;1;KG
5278;48026192;Papel Kraft, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico;1;KG
5279;48026199;Outros papeis e cartoes, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico;1;KG
5280;48026210;Outros papeis e cartoes, > 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, em folhas em que um lado < 435 mm e o outro <  297 mm, quando nao dobradas, etc...;1;KG
5281;48026291;Outros papeis e cartoes, em folhas em que um lado nao seja < 435 mm e o outro < 297 mm, quando nao dobradas, de peso <= 57 g/m2, em que 65 % ou mais, em peso, do conteudo total de fibras seja constituido por fibras de madeira obtidas por processo mecanico;1;KG
5282;48026292;Outros papeis e cartoes Kraft, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, em folhas em que um lado < 435 mm e o outro < 297 mm, quando nao dobradas;1;KG
5283;48026299;Outros papeis e cartoes, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, em folhas em que um lado < 435 mm e o outro < 297 mm, quando nao dobradas;1;KG
5284;48026910;Outros papeis e cartoes, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, em tiras de largura < 15 cm ou em folhas em que nenhum lado exceda 360 mm,quando nao dobradas;1;KG
5285;48026991;Outros papeis e cartoes, de peso inferior ou igual a 57 g/m2, em que 65 % ou mais, em peso, do conteudo total de fibras seja constituido por fibras de madeira obtidas por processo mecanico;1;KG
5286;48026992;Outros papeis e cartoes Kraft, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico;1;KG
5287;48026999;Outros papeis/cartoes, fibra mecanica >10%;1;KG
5288;48030010;Pasta de celulose e mantas de fibras de celulose;1;KG
5289;48030090;Papel dos tipos utilizados para papel de toucador, toalhas, guardanapos ou para papeis semelhantes de uso domestico, higienico ou toucador;1;KG
5290;48041100;Papel e cartao para cobertura, denominados Kraftliner, crus, em rolos ou em folhas;1;KG
5291;48041900;Outros papeis e cartoes para cobertura, denominados Kraftliner, em rolos ou em folhas;1;KG
5292;48042100;Papel Kraft para sacos de grande capacidade, cru, em rolos ou em folhas;1;KG
5293;48042900;Outros papeis Kraft para sacos de grande capacidade, em rolos ou em folhas;1;KG
5294;48043110;Outros papeis e cartoes Kraft de peso nao superior a 150 g/m2, crus, de rigidez dieletrica igual ou superior a 600 V (metodo ASTM D 202 ou equivalente), em rolos ou em folhas;1;KG
5295;48043190;Outros papeis e cartoes Kraft de peso nao superior a 150 g/m2, crus, em rolos ou em folhas;1;KG
5296;48043910;Outros papeis e cartoes Kraft de peso nao superior a 150 g/m2, de rigidez dieletrica igual ou superior a 600 V (metodo ASTM D 202 ou equivalente), em rolos ou em folhas;1;KG
5297;48043990;Outros papeis e cartoes Kraft de peso nao superior a 150 g/m2, em rolos ou em folhas;1;KG
5298;48044100;Outros papeis e cartoes Kraft de peso superior a 150 g/m2, mas inferior a 225 g/m2, crus, em rolos ou em folhas;1;KG
5299;48044200;Outros papeis e cartoes Kraft de peso superior a 150 g/m2,mas inferior a 225 g/m2,branqueados uniformemente na massa e em que mais de 95 %,em peso,do conteudo total de fibras seja constituido por fibras de madeira obtidas por processo quimico,rolos/folhas;1;KG
5300;48044900;Outros papeis e cartoes Kraft de peso superior a 150 g/m2, mas inferior a 225 g/m2, em rolos ou em folhas;1;KG
5301;48045100;Outros papeis e cartoes Kraft de peso igual ou superior a 225 g/m2, crus, em rolos ou em folhas;1;KG
5302;48045200;Outros papeis e cartoes Kraft de peso igual ou superior a 225 g/m2, branqueados uniformemente na massa e em que mais de 95 %, em peso, do conteudo total de fibras seja constituido por fibras de madeira obtidas por processo quimico, em rolos ou em folhas;1;KG
5303;48045910;Papel Kraft de peso igual ou superior a 225 g/m2, semibranqueados, com um conteudo de 100 %, em peso, de fibras de madeira obtidas por processo quimico, em rolos ou em folhas;1;KG
5304;48045990;Outros papeis e cartoes Kraft, de peso igual ou superior a 225 g/m2, em rolos ou em folhas;1;KG
5305;48051100;Papel semiquimico para ondular, nao revestidos, em rolos ou em folhas, nao tendo sofrido trabalho complementar nem tratamentos;1;KG
5306;48051200;Papel palha para ondular, nao revestidos, em rolos ou em folhas, nao tendo sofrido trabalho complementar nem tratamentos;1;KG
5307;48051900;Outros papeis para ondular, nao revestidos, em rolos ou em folhas, nao tendo sofrido trabalho complementar nem tratamentos;1;KG
5308;48052400;Papel testliner (fibras recicladas), nao revestido, em rolos ou folhas, de peso nao superior a 150 g/m2;1;KG
5309;48052500;Papel testliner (fibras recicladas), nao revestido, em rolos ou folhas, de peso superior a 150 g/m2;1;KG
5310;48053000;Papel sulfite de embalagem, nao revestido, em rolos ou folhas;1;KG
5311;48054010;Papel-filtro e cartao-filtro, de peso superior a 15 g/m2 mas inferior ou igual a 25 g/m2, com um conteudo de fibras sinteticas termossoldaveis igual ou superior a 20 % mas inferior ou igual a 30 %, em peso, do conteudo total de fibras;1;KG
5312;48054090;Outro papel-filtro e cartao-filtro, nao revestido, em rolos ou folhas;1;KG
5313;48055000;Papel-feltro e cartao-feltro, papel e cartao lanosos;1;KG
5314;48059100;Outros papeis e cartoes nao revestidos, em rolos ou folhas, de peso nao superior a 150 g/m2;1;KG
5315;48059210;Papel com fibras de vidro, de peso superior a 150 g/m2, mas inferior a 225 g/m2;1;KG
5316;48059290;Outros papeis nao revestidos, em rolos ou folhas, de peso superior a 150 g/m2, mas inferior a 225 g/m2;1;KG
5317;48059300;Outros papeis e cartoes nao revestidos, em rolos ou folhas, de peso igual ou superior a 225 g/m2;1;KG
5318;48061000;Papel-pergaminho e cartao-pergaminho (sulfurizados), em rolos ou em folhas;1;KG
5319;48062000;Papel impermeavel a gorduras, em rolos ou em folhas;1;KG
5320;48063000;Papel vegetal, em rolos ou em folhas;1;KG
5321;48064000;Papel cristal e outros papeis calandrados transparentes ou translucidos, em rolos ou em folhas;1;KG
5322;48070000;Papel e cartao obtidos por colagem de folhas sobrepostas, nao revestidos na superficie nem impregnados, mesmo reforcados interiormente, em rolos ou em folhas;1;KG
5323;48081000;Papel e cartao ondulados, mesmo perfurados, em rolos ou em folhas;1;KG
5324;48084000;Papeis Kraft, encrespados ou plissados, mesmo gofrados, estampados ou perfurados;1;KG
5325;48089000;Outros papeis/cartoes ondulados, encrespados, etc, em rolos ou folhas;1;KG
5326;48092000;Papel autocopiativo, em rolos ou em folhas;1;KG
5327;48099000;Outros papeis para copia ou duplicacao (incluindo os papeis, revestidos ou impregnados, para estenceis ou para chapas ofsete), mesmo impressos, em rolos ou em folhas;1;KG
5328;48101310;Papel e cartao dos tipos utilizados para escrita,impressao ou outras finalidades graficas,sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %,em peso,do conteudo total de fibras,em rolos,largura < 15cm;1;KG
5329;48101381;Papeis e cartoes metalizados, sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras nao seja superior a 10 %, em peso, do conteudo total de fibras, em rolos, de peso superior a 150 g/m2;1;KG
5330;48101382;Papeis e cartoes baritados, sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras nao seja superior a 10 %, em peso, do conteudo total de fibras, em rolos, de peso superior a 150 g/m2;1;KG
5331;48101389;Outros papeis e cartoes, dos tipos utilizados para escrita, etc, fibra <= 10%, rolos, peso >150g/m2;1;KG
5332;48101390;Outros papeis e cartoes para escrita, etc, fibra <= 10%, em rolos;1;KG
5333;48101410;Papel para escrita, etc, em folhas em que um dos lados nao seja superior a 435 mm e o outro nao seja superior a 297 mm, quando nao dobradas, em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5334;48101481;Papel metalizado,sem fibra obtida por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %,em peso,do conteudo total de fibras,de peso > 150 g/m2,em folhas em que um dos lados < 435 mm e o outro <  297 mm,quando nao dobradas;1;KG
5335;48101482;Papel baritado, sem fibra obtida por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %,em peso,do conteudo total de fibras,de peso > 150 g/m2,em folhas em que um dos lados < 435 mm e o outro <  297 mm,quando nao dobradas;1;KG
5336;48101489;Outros papeis para escrita, etc, fibra <= 10%, de peso > 150 g/m2, em folhas em que um dos lados < 435 mm e o outro <  297 mm, quando nao dobradas;1;KG
5337;48101490;Outros papeis para escrita, etc, fibra <= 10%, em folhas em que um dos lados < 435 mm e o outro <  297 mm, quando nao dobradas;1;KG
5338;48101910;Outros papeis para escrita, etc, fibra <= 10%, em tiras de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5339;48101981;Outros papeis metalizados, de peso superior a 150 g/m2, fibra <= 10%;1;KG
5340;48101982;Outros papeis baritados (revestidos de oxido ou sulfato de bario), de peso superior a 150 g/m2, fibra <= 10%;1;KG
5341;48101989;Outros papeis e cartoes dos tipos utilizados para escrita, impressao ou outras finalidades graficas,sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %,em peso,do conteudo total de fibras, p > 150 g/m2;1;KG
5342;48101990;Outros papeis e cartoes dos tipos utilizados para escrita, impressao ou outras finalidades graficas,sem fibras obtidas por processo mecanico ou quimico-mecanico ou em que a percentagem destas fibras < 10 %,em peso,do conteudo total de fibras;1;KG
5343;48102210;Papel cuche leve (L.W.C. - lightweight coated), em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5344;48102290;Outros papeis cuche leves (L.W.C. - lightweight coated);1;KG
5345;48102910;Papel e cartao dos tipos utilizados para escrita, impressao etc, > 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico, tiras/rolos l < 15 cm ou folhas em que nenhum lado > 360 mm, etc..;1;KG
5346;48102990;Outros papeis e cartoes dos tipos utilizados para escrita, impressao ou outras finalidades graficas, em que mais de 10 %, em peso, do conteudo total de fibras seja constituido por fibras obtidas por processo mecanico ou quimico-mecanico;1;KG
5347;48103110;Papel e cartao Kraft, exceto dos tipos utilizados para escrita, impressao ou outras finalidades graficas, branqueado uniformemente na massa e em que mais de 95 %, em peso, do conteudo total de fibras seja constituido por fibras de madeira obtidas etc...;1;KG
5348;48103190;Outro papel e cartao Kraft, exceto do tipo utilizado para escrita, impressao ou outras finalidade grafica, branqueado uniformemente na massa e em que mais de 95 %, em peso, peso <= 150g/m2, etc...;1;KG
5349;48103210;Papel e cartao Kraft, branqueados uniformemente na massa e > 95 %,em peso,do conteudo total de fibras seja constituido por fibras de madeira obtidas por processo quimico,p > 150 g/m2,tiras ou rolos de largura < 15 cm ou em folhas em que nenhum lado >360mm;1;KG
5350;48103290;Outros papeis Kraft, branqueados uniformemente na massa e em que mais de 95 %, em peso, do conteudo total de fibras seja constituido por fibras de madeira obtidas por processo quimico, de peso superior a 150 g/m2;1;KG
5351;48103910;Outros papeis e cartoes Kraft, exceto dos tipos utilizados para escrita, impressao ou outras finalidades graficas, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5352;48103990;Outros papeis e cartoes Kraft, exceto dos tipos utilizados para escrita, impressao ou outras finalidades graficas;1;KG
5353;48109210;Outros papeis e cartoes, de camadas multiplas, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5354;48109290;Outros papeis e cartoes de camadas multiplas, revestidos de caulim, em rolos ou folhas;1;KG
5355;48109910;Outros papeis e cartoes revestidos de caulim, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5356;48109990;Outros papeis/cartoes, revestidos de caulim, em rolos/folhas;1;KG
5357;48111010;Papel e cartao de celulose, alcatroados, betumados ou asfaltados, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas, em rolos ou em folhas de forma quadrada ou retangular;1;KG
5358;48111090;Outros papeis e cartoes de celulose, alcatroados, betumados ou asfaltados, em rolos ou em folhas de forma quadrada ou retangular;1;KG
5359;48114110;Papel e cartao auto-adesivos, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5360;48114190;Outros papeis e cartoes auto-adesivos, em rolos ou folhas;1;KG
5361;48114910;Outros papeis e cartoes auto-adesivos, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5362;48114990;Outros papeis e cartoes gomados ou adesivos, em rolos ou em folhas;1;KG
5363;48115110;Papel e cartao revestidos, impregnados ou recobertos de plastico (exceto os adesivos), branqueados, de peso superior a 150 g/m2, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5364;48115121;Papel e cartao recobertos ou revestidos de silicone, exceto gofrados na face recoberta ou revestida, branqueados, de peso superior a 150 g/m2;1;KG
5365;48115122;Papel e cartao recobertos ou revestidos de polietileno, estratificado com aluminio, impresso, branqueados, de peso superior a 150 g/m2;1;KG
5366;48115123;Papel e cartao recobertos ou revestidos de polietileno ou polipropileno, em ambas as faces, base para papel fotografico, branqueados, de peso superior a 150 g/m2;1;KG
5367;48115128;Outros papeis gofrados na face recoberta ou revestida, branqueados, de peso superior a 150 g/m2;1;KG
5368;48115129;Outros papeis e cartoes revestidos, recobertos de plastico (exceto os adesivos), branqueados, de peso superior a 150 g/m2;1;KG
5369;48115130;Outros papeis e cartoes revestidos, impregnados, branqueados, de peso superior a 150 g/m2;1;KG
5370;48115910;Papel e cartao revestidos, impregnados ou recobertos de plastico (exceto os adesivos), em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5371;48115921;Papel e cartao revestidos, impregnados ou recobertos de plastico (exceto os adesivos), recobertos ou revestidos de polietileno ou polipropileno, em ambas as faces, base para papel fotografico, em rolos ou folhas;1;KG
5372;48115922;Papel e cartao revestidos, impregnados ou recobertos de plastico (exceto os adesivos), recobertos ou revestidos de silicone, em rolos ou folhas;1;KG
5373;48115923;Papel e cartao revestidos, impregnados ou recobertos de plastico (exceto os adesivos), recobertos ou revestidos de polietileno, estratificado com aluminio, impresso, em rolos ou folhas;1;KG
5374;48115929;Papel e cartao revestidos, impregnados ou recobertos de plastico (exceto os adesivos), recobertos ou revestidos com outros plasticos, em rolos ou folhas;1;KG
5375;48115930;Outros papeis impregnados de plasticos em rolos/folhas;1;KG
5376;48116010;Papel e cartao revestidos, impregnados ou recobertos de cera, parafina, estearina, oleo ou glicerol, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5377;48116090;Outros papeis e cartoes revestidos, impregnados ou recobertos de cera, parafina, estearina, oleo ou glicerol;1;KG
5378;48119010;Outros papeis, cartoes, pasta (ouate) de celulose e mantas de fibras de celulose, em tiras ou rolos de largura nao superior a 15 cm ou em folhas em que nenhum lado exceda 360 mm, quando nao dobradas;1;KG
5379;48119090;Outros papeis, cartoes, pasta (ouate) de celulose e mantas de fibras de celulose;1;KG
5380;48120000;Blocos e chapas, filtrantes, de pasta de papel;1;KG
5381;48131000;Papel para cigarros, mesmo cortado nas dimensoes proprias, em cadernos ou em tubos;1;KG
5382;48132000;Papel para cigarros, em rolos de largura nao superior a 5 cm;1;KG
5383;48139000;Outros papeis para cigarros;1;KG
5384;48142000;Papel de parede e revestimentos de parede semelhantes, constituidos por papel revestido ou recoberto, no lado da face, por uma camada de plastico granida, gofrada, colorida, impressa com desenhos ou decorada de qualquer outra forma;1;KG
5385;48149000;Outros papeis de parede e revestimentos de parede semelhantes, papel para vitrais;1;KG
5386;48162000;Papel autocopiativo, mesmo acondicionados em caixas;1;KG
5387;48169010;Papel-carbono e semelhantes, mesmo acondicionados em caixas;1;KG
5388;48169090;Outros papeis autocopiativos, estenceis, chapa ofsete;1;KG
5389;48171000;Envelopes, de papel ou cartao;1;KG
5390;48172000;Aerogramas, bilhetes-postais nao ilustrados e cartoes para correspondencia;1;KG
5391;48173000;Caixas, sacos e semelhantes, de papel ou cartao, que contenham um sortido de artigos para correspondencia;1;KG
5392;48181000;Papel higienico;1;KG
5393;48182000;Lencos, incluindo os de desmaquiar, e toalhas de mao, de papel;1;KG
5394;48183000;Toalhas de mesa e guardanapos, de papel;1;KG
5395;48185000;Vestuario e seus acessorios, de papel;1;KG
5396;48189010;Almofadas absorventes dos tipos utilizados em embalagens de produtos alimenticios;1;KG
5397;48189090;Outros artigos de papel, para uso sanitario/domestico/hospitalar;1;KG
5398;48191000;Caixas de papel ou cartao, ondulados;1;KG
5399;48192000;Caixas e cartonagens, dobraveis, de papel ou cartao, nao ondulados;1;KG
5400;48193000;Sacos cuja base tenha largura igual ou superior a 40 cm, de papel ou cartao;1;KG
5401;48194000;Outros sacos, bolsas e cartuchos, de papel ou cartao;1;KG
5402;48195000;Outras embalagens, incluindo as capas para discos, de papel ou cartao;1;KG
5403;48196000;Cartonagens para escritorios, lojas e estabelecimentos semelhantes;1;KG
5404;48201000;Livros de registro e de contabilidade, blocos de notas, de encomendas, de recibos, de apontamentos, de papel para cartas, agendas e artigos semelhantes;1;KG
5405;48202000;Cadernos;1;KG
5406;48203000;Classificadores, capas para encadernacao (exceto as capas para livros) e capas de processos;1;KG
5407;48204000;Formularios em blocos tipo manifold, mesmo com folhas intercaladas de papel-carbono;1;KG
5408;48205000;Albuns para amostras ou colecoes, de papel ou cartao;1;KG
5409;48209000;Outros artigos de papel/cartao, para escritorio/papelaria, etc;1;KG
5410;48211000;Etiquetas de qualquer especie, de papel ou cartao, impressas;1;KG
5411;48219000;Etiquetas de qualquer especie, de papel ou cartao, exceto impressas;1;KG
5412;48221000;Carreteis, bobinas, canelas e suportes semelhantes, de pasta de papel, papel ou cartao, mesmo perfurados ou endurecidos, dos tipos utilizados para enrolamento de fios texteis;1;KG
5413;48229000;Carreteis, bobinas, canelas e suportes semelhantes, de pasta de papel, papel ou cartao, mesmo perfurados ou endurecidos, para outros usos;1;KG
5414;48232010;Papel-filtro e cartao-filtro, de peso superior a 15 g/m2 mas inferior ou igual a 25 g/m2, com um conteudo de fibras sinteticas termossoldaveis igual ou superior a 20 % mas inferior ou igual a 30 %, em peso, do conteudo total de fibras;1;KG
5415;48232091;Papel-filtro e cartao-filtro, em tiras ou rolos de largura superior a 15 cm, mas nao superior a 36 cm;1;KG
5416;48232099;Outros papeis filtro/cartao filtro, de celulose;1;KG
5417;48234000;Papeis-diagrama para aparelhos registradores, em bobinas, em folhas ou em discos;1;KG
5418;48236100;Bandejas, travessas, pratos, xicaras (chavenas), tacas, copos e artigos semelhantes, de bambu;1;KG
5419;48236900;Bandejas, travessas, pratos, xicaras (chavenas), tacas, copos e artigos semelhantes, de papel ou cartao;1;KG
5420;48237000;Artigos moldados ou prensados, de pasta de papel;1;KG
5421;48239010;Cartoes perfurados para mecanismos Jacquard;1;KG
5422;48239020;Papel e cartao, de rigidez dieletrica superior ou igual a 600 V (metodo ASTM D 202 ou equivalente) e de peso inferior ou igual a 60 g/m2;1;KG
5423;48239091;Outros papeis, etc, de celulose, rolos 15 cm < largura <= 36 cm;1;KG
5424;48239099;Outros papeis, cartoes de celulose e outras obras de papel;1;KG
5425;49011000;Livros, brochuras e impressos semelhantes, em folhas soltas, mesmo dobradas;1;KG
5426;49019100;Dicionarios e enciclopedias, mesmo em fasciculos;1;KG
5427;49019900;Outros livros, brochuras e impressos semelhantes;1;KG
5428;49021000;Jornais e publicacoes periodicas, impressos, mesmo ilustrados ou que contenham publicidade, que se publiquem pelo menos quatro vezes por semana;1;KG
5429;49029000;Outros jornais e publicacoes periodicas, impressos, mesmo ilustrados ou que contenham publicidade;1;KG
5430;49030000;Albuns ou livros de ilustracoes e albuns para desenhar ou colorir, para criancas;1;KG
5431;49040000;Musica manuscrita ou impressa, ilustrada ou nao, mesmo encadernada;1;KG
5432;49051000;Globos (obra cartografica, impressa);1;KG
5433;49059100;Obras cartograficas, sob a forma de livros ou brochuras;1;KG
5434;49059900;Outras obras cartograficas, impressas;1;KG
5435;49060000;Planos, plantas e desenhos, de arquitetura, de engenharia e outros planos e desenhos industriais, comerciais, topograficos ou semelhantes, originais, feitos a mao, textos manuscritos, reproducoes fotograficas em papel sensibilizado, etc;1;KG
5436;49070010;Papeis-moeda;1;KG
5437;49070020;Cheques de viagem;1;KG
5438;49070030;Titulos de acoes ou de obrigacoes e titulos semelhantes, convalidados e firmados;1;KG
5439;49070090;Selos postais, fiscais, etc, nao obliterados, com curso legal;1;KG
5440;49081000;Decalcomanias vitrificaveis;1;KG
5441;49089000;Outras decalcomanias de qualquer especie;1;KG
5442;49090000;Cartoes-postais impressos ou ilustrados, cartoes impressos com votos ou mensagens pessoais, mesmo ilustrados, com ou sem envelopes, guarnicoes ou aplicacoes;1;KG
5443;49100000;Calendarios de qualquer especie, impressos, incluindo os blocos-calendarios para desfolhar;1;KG
5444;49111010;Impressos publicitarios, catalogos comerciais e semelhantes, que contenham informacoes relativas ao funcionamento, manutencao, reparo ou utilizacao de maquinas, aparelhos, veiculos e outras mercadorias de origem extrazona;1;KG
5445;49111090;Outros impressos publicitarios, catalogos comerciais e semelhantes;1;KG
5446;49119100;Estampas, gravuras e fotografias;1;KG
5447;49119900;Outros impressos;1;KG
5448;50010000;Casulos de bicho-da-seda proprios para dobar;1;KG
5449;50020000;Seda crua (nao fiada);1;KG
5450;50030010;Desperdicios de seda, nao cardados, nao penteados;1;KG
5451;50030090;Outros desperdicios de seda;1;KG
5452;50040000;Fios de seda (exceto fios de desperdicios de seda) nao acondicionados para venda a retalho;1;KG
5453;50050000;Fios de desperdicios de seda, nao acondicionados para venda a retalho;1;KG
5454;50060000;Fios de seda ou de desperdicios de seda, acondicionados para venda a retalho, pelo de Messina (crina de Florenca);1;KG
5455;50071010;Tecidos de bourrette de seda, estampados, tintos ou de fios de diversas cores;1;KG
5456;50071090;Outros tecidos de bourrette de seda;1;KG
5457;50072010;Outros tecidos que contenham pelo menos 85 %, em peso, de seda ou de desperdicios de seda, exceto bourrette, estampados, tintos ou de fios de diversas cores;1;KG
5458;50072090;Outros tecidos que contenham pelo menos 85 %, em peso, de seda ou de desperdicios de seda, exceto bourrette;1;KG
5459;50079000;Outros tecidos de seda ou de desperdicios de seda;1;KG
5460;51011110;La suja, incluindo a la lavada a dorso, nao cardada nem penteada, de tosquia, de finura superior ou igual 22,05 micrometros (microns) mas inferior ou igual a 32,6 micrometros (microns);1;KG
5461;51011190;Outras las de tosquia, suja, incluindo a la lavada a dorso, nao cardada nem penteada;1;KG
5462;51011900;Outras las sujas, nao cardadas nem penteadas;1;KG
5463;51012100;La de tosquia, desengordurada, nao carbonizada, nao cardada, nao penteada;1;KG
5464;51012900;Outras las desengorduradas nao carbonizadas, nao cardadas,  nao penteadas;1;KG
5465;51013000;La desengordurada, carbonizada, nao cardada nem penteada;1;KG
5466;51021100;Pelos finos, nao cardados nem penteados, de cabra de Caxemira;1;KG
5467;51021900;Pelos finos, nao cardados nem penteados;1;KG
5468;51022000;Pelos grosseiros, nao cardados nem penteados;1;KG
5469;51031000;Desperdicios da penteacao de la ou de pelos finos;1;KG
5470;51032000;Outros desperdicios de la ou de pelos finos;1;KG
5471;51033000;Desperdicios de pelos grosseiros;1;KG
5472;51040000;Fiapos de la ou de pelos finos ou grosseiros;1;KG
5473;51051000;La cardada;1;KG
5474;51052100;La penteada a granel;1;KG
5475;51052910;Tops de la penteada;1;KG
5476;51052991;Outras las penteadas, de finura inferior a 22,5 micrometros (microns);1;KG
5477;51052999;Outras las penteadas;1;KG
5478;51053100;Pelos finos, cardados ou penteados, de cabra de Caxemira;1;KG
5479;51053900;Outros pelos finos, cardados ou penteados;1;KG
5480;51054000;Pelos grosseiros, cardados ou penteados;1;KG
5481;51061000;Fios de la cardada, nao acondicionados para venda a retalho, que contenham pelo menos 85 %, em peso, de la;1;KG
5482;51062000;Fios de la cardada, nao acondicionados para venda a retalho, que contenham menos de 85 %, em peso, de la;1;KG
5483;51071011;Fios de la penteada, nao acondicionados para venda a retalho, que contenham pelo menos 85 %, em peso, de la, retorcidos ou retorcidos multiplos, de dois cabos, de titulo inferior ou igual a 184,58 decitex por cabo;1;KG
5484;51071019;Outros fios de la penteada, retorcidos ou retorcidos multiplos, que contenham pelo menos 85 %, em peso, de la;1;KG
5485;51071090;Outros fios de la penteada que contenham pelo menos 85 %, em peso, de la;1;KG
5486;51072000;Fios de la penteada que contenham menos de 85 %, em peso, de la;1;KG
5487;51081000;Fios de pelos finos, cardados, nao acondicionados para venda a retalho.;1;KG
5488;51082000;Fios de pelos finos, penteados, nao acondicionados para venda a retalho.;1;KG
5489;51091000;Fios de la ou de pelos finos, acondicionados para venda a retalho, que contenham pelo menos 85 %, em peso, de la ou de pelos finos;1;KG
5490;51099000;Outros fios de la ou de pelos finos, acondicionados para venda a retalho;1;KG
5491;51100000;Fios de pelos grosseiros ou de crina (incluindo os fios de crina revestidos por enrolamento), mesmo acondicionados para venda a retalho;1;KG
5492;51111110;Tecidos de la cardada, que contenham pelo menos 85 %, em peso, de la, de peso nao superior a 300 g/m2;1;KG
5493;51111120;Tecidos de pelos finos, que contenham pelo menos 85 %, em peso, de pelos finos, de peso nao superior a 300 g/m2;1;KG
5494;51111900;Outros tecidos de la/pelos finos, cardados que contenham pelo menos 85 %, em peso, de la ou de pelos finos;1;KG
5495;51112000;Tecido de la/pelos finos, cardados, combinados, principal ou unicamente, com filamentos sinteticos ou artificiais;1;KG
5496;51113010;Tecido de la, cardada, feltrados, com trama combinada exclusivamente com fibras sinteticas e urdidura exclusivamente de algodao, de peso superior ou igual a 600 g/m2, proprios para fabricacao de bolas de tenis;1;KG
5497;51113090;Outros tecidos de la/pelos finos, cardados, com fibra sintetica/artificial;1;KG
5498;51119000;Outros tecidos de la ou de pelos finos, cardados;1;KG
5499;51121100;Tecidos de la penteada ou de pelos finos penteados, que contenham pelo menos 85 %, em peso, de la ou de pelos finos, de peso nao superior a 200 g/m2;1;KG
5500;51121910;Outros tecidos de la penteada, que contenham pelo menos 85 %, em peso, de la;1;KG
5501;51121920;Outros tecidos de pelos finos, que contenham pelo menos 85 %, em peso, de pelos finos;1;KG
5502;51122010;Outros, combinados, principal ou unicamente, com filamentos sinteticos ou artificiais, de la;1;KG
5503;51122020;Outros, combinados, principal ou unicamente, com filamentos sinteticos ou artificiais, de pelos finos;1;KG
5504;51123010;Outros, combinados, principal ou unicamente, com fibras sinteticas ou artificiais descontinuas, de la;1;KG
5505;51123020;Outros, combinados, principal ou unicamente, com fibras sinteticas ou artificiais descontinuas, de pelos finos;1;KG
5506;51129000;Outros tecido de la ou de pelos finos, penteados;1;KG
5507;51130011;Tecidos de pelos grosseiros, que contenham pelo menos 85 %, em peso, de pelos grosseiros;1;KG
5508;51130012;Tecidos de pelos grosseiros, que contenham menos de 85 %, em peso, de pelos grosseiros e que contenham algodao;1;KG
5509;51130013;Tecidos de pelos grosseiros, que contenham menos de 85 %, em peso, de pelos grosseiros e que nao contenham algodao;1;KG
5510;51130020;Tecidos de crina;1;KG
5511;52010010;Algodao nao cardado nem penteado, nao debulhado;1;TON
5512;52010020;Algodao nao cardado nem penteado, simplesmente debulhado;1;TON
5513;52010090;Outros tipos de algodao nao cardado nem penteado;1;TON
5514;52021000;Desperdicios de fios de algodao;1;KG
5515;52029100;Fiapos de algodao;1;KG
5516;52029900;Outros desperdicios de algodao;1;KG
5517;52030000;Algodao cardado ou penteado;1;KG
5518;52041111;Linhas para costurar, nao acondicionadas para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao, de algodao cru, de titulo inferior ou igual a 5.000 decitex por fio simples, de dois cabos;1;KG
5519;52041112;Linhas para costurar, nao acondicionadas para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao, de algodao cru, de titulo inferior ou igual a 5.000 decitex por fio simples, de tres ou mais cabos;1;KG
5520;52041120;Linhas para costurar, nao acondicionadas para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao, de algodao cru, de titulo superior a 5.000 decitex por fio simples;1;KG
5521;52041131;Linhas para costurar, nao acondicionadas para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao, de algodao branqueado ou colorido, de titulo inferior ou igual a 5.000 decitex por fio simples, de dois cabos;1;KG
5522;52041132;Linhas para costurar, nao acondicionadas para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao, de algodao branqueado ou colorido, de titulo inferior ou igual a 5.000 decitex por fio simples, de tres ou mais cabos;1;KG
5523;52041140;Linhas para costurar, nao acondicionadas para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao, de algodao branqueado ou colorido, de titulo superior a 5.000 decitex por fio simples;1;KG
5524;52041911;Outras linhas para costurar, de algodao cru, de titulo inferior ou igual a 5.000 decitex por fio simples, de dois cabos;1;KG
5525;52041912;Outras linhas para costurar, de algodao cru, de titulo superior a 5.000 decitex por fio simples, de tres ou mais cabos;1;KG
5526;52041920;Outras linhas para costurar, de algodao cru, de titulo inferior ou igual a 5.000 decitex por fio simples;1;KG
5527;52041931;Linhas para costurar, de algodao, nao acondicionadas para venda a retalho, de algodao branqueado ou colorido, de titulo inferior ou igual a 5.000 decitex por fio simples, de dois cabos;1;KG
5528;52041932;Linhas para costurar, de algodao, nao acondicionadas para venda a retalho, de algodao branqueado ou colorido, de titulo inferior ou igual a 5.000 decitex por fio simples, de tres ou mais cabos;1;KG
5529;52041940;Linhas para costurar, de algodao, nao acondicionadas para venda a retalho, de algodao branqueado ou colorido, de titulo superior a 5.000 decitex por fio simples;1;KG
5530;52042000;Outras linhas para costura, de algodao, acondicionadas para venda a retalho;1;KG
5531;52051100;Fios simples de algodao, de fibras nao penteadas, de titulo igual ou superior a 714,29 decitex (numero metrico nao superior a 14), nao acondicionados para venda a retalho;1;KG
5532;52051200;Fios simples de algodao, de fibras nao penteadas, de titulo inferior a 714,29 decitex mas nao inferior a 232,56 decitex (numero metrico superior a 14 mas nao superior a 43), nao acondicionados para venda a retalho;1;KG
5533;52051310;Fios simples de algodao, de fibras nao penteadas, de titulo inferior a 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43 mas nao superior a 52), crus, nao acondicionados para venda a retalho;1;KG
5534;52051390;Outros fios simples de algodao, de fibras nao penteadas, de titulo inferior a 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43 mas nao superior a 52), nao acondicionados para venda a retalho;1;KG
5535;52051400;Fios de algodao simples, de fibras nao penteadas, de titulo inferior a 192,31 decitex mas nao inferior a 125 decitex (numero metrico superior a 52 mas nao superior a 80), nao acondicionados para venda a retalho;1;KG
5536;52051500;Fios de algodao simples, de fibras nao penteadas, de titulo inferior a 125 decitex (numero metrico superior a 80), nao acondicionados para venda a retalho;1;KG
5537;52052100;Fios de algodao simples, de fibras penteadas, de titulo igual ou superior a 714,29 decitex (numero metrico nao superior a 14);1;KG
5538;52052200;Fios de algodao simples, de fibras penteadas, de titulo inferior a 714,29 decitex mas nao inferior a 232,56 decitex (numero metrico superior a 14 mas nao superior a 43);1;KG
5539;52052310;Fios de algodao simples, de fibras penteadas, de titulo inferior a 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43 mas nao superior a 52), crus;1;KG
5540;52052390;Outros fios de algodao simples, de fibras penteadas, de titulo inferior a 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43 mas nao superior a 52);1;KG
5541;52052400;Fios simples de algodao, de fibras penteadas, que contenham pelo menos 85 %,em peso,de algodao,nao acondicionados para venda a retalho, de titulo inferior a 192,31 decitex mas nao inferior a 125 decitex (numero metrico superior a 52 mas nao superior a 80);1;KG
5542;52052600;Fios simples de algodao,de fibras penteadas,que contenham pelo menos 85 %, em peso, de algodao,nao acondicionados para venda a retalho, de titulo inferior a 125 decitex mas nao inferior a 106,38 decitex (numero metrico superior a 80 mas nao superior a 94);1;KG
5543;52052700;Fios simples de algodao,de fibras penteadas,que contenham pelo menos 85 %,em peso,de algodao,nao acondicionados para venda a retalho,de titulo inferior a 106,38 decitex mas nao inferior a 83,33 decitex (numero metrico superior a 94 mas nao superior a 120);1;KG
5544;52052800;Fios simples de algodao, de fibras penteadas, que contenham pelo menos 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo inferior a 83,33 decitex (numero metrico superior a 120);1;KG
5545;52053100;Fios de algodao retorcidos ou retorcidos multiplos, de fibras nao penteadas, que contenham pelo menos 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo >= 714,29 decitex por fio simples (numero metrico < 14, por fio simples);1;KG
5546;52053200;Fios de algodao retorcidos ou retorcidos multiplos, de fibras nao penteadas, que contenham pelo menos 85 %, em peso, de algodao, de titulo < 714,29 decitex mas > 232,56 decitex, por fio simples (numero metrico > 14 e < 43, por fio simples);1;KG
5547;52053300;Fios de algodao retorcidos ou retorcidos multiplos, de fibras nao penteadas, que contenham pelo menos 85 %, em peso, de algodao, de titulo < 232,56 decitex mas > 192,31 decitex, por fio simples (numero metrico > 43 mas < 52, por fio simples);1;KG
5548;52053400;Fios de algodao retorcidos ou retorcidos multiplos, de fibras nao penteadas, que contenham pelo menos 85 %, em peso, de algodao, de titulo < 192,31 decitex mas > 125 decitex, por fio simples (numero metrico > 52 mas < 80, por fio simples);1;KG
5549;52053500;Fios de algodao retorcidos ou retorcidos multiplos, de fibras nao penteadas, que contenham pelo menos 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 125 decitex por fio simples (numero metrico > 80, por fio simples);1;KG
5550;52054100;Fios de algodao que contenham pelo menos 85 %, em peso, de algodao, nao acondicionados para venda a retalho, retorcidos ou retorcidos multiplos, de fibras penteadas, de titulo >= 714,29 decitex por fio simples (numero metrico < 14, por fio simples);1;KG
5551;52054200;Fios de algodao que contenham pelo menos 85 %,em peso,de algodao,nao acondicionados para venda a retalho,retorcidos ou retorcidos multiplos,fibras penteadas,titulo < 714,29 decitex mas > 232,56 decitex,por fio simples (num.met >14 e < 43, por fio simples);1;KG
5552;52054300;Fios de algodao contendo ao menos 85 %,em peso,de algodao,nao acondicionados para venda retalho,retorcidos ou retorcidos multiplos,fibras penteadas,titulo < 232,56 decitex mas > 192,31 decitex,por fio simples (num.met.> 43 mas < 52, por fio simples);1;KG
5553;52054400;Fios de algodao contendo ao menos 85 %,em peso,de algodao,nao acondicionados para venda a retalho, retorcidos ou retorcidos multiplos, fibras penteadas, titulo < 192,31 decitex mas > 125 decitex,por fio simples (numero metrico > 52 mas <  80, fio simples);1;KG
5554;52054600;Fios de algodao contendo ao menos 85 %, peso,de algodao,nao acondicionados para venda a retalho, retorcidos ou retorcidos multiplos,fibras penteadas, titulo < 125 decitex mas > 106,38 decitex, por fio simples (numero metrico > 80 mas < 94,por fio simples);1;KG
5555;52054700;Fios de algodao contendo ao menos 85 %, em peso,de algodao, nao acondicionados para venda a retalho, retorcidos ou retorcidos multiplos, fibras penteadas, titulo < 106,38 decitex mas > 83,33 decitex,por fio simples (num.met. > 94 e < 120, por fio simples);1;KG
5556;52054800;Fios de algodao contendo ao menos 85 %, em peso,de algodao, nao acondicionados para venda a retalho,retorcidos ou retorcidos multiplos,de fibras penteadas, de titulo inferior a 83,33 decitex por fio simples (numero metrico superior a 120, por fio simples);1;KG
5557;52061100;Fios simples de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo igual ou superior a 714,29 decitex (numero metrico nao superior a 14);1;KG
5558;52061200;Fios simples de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 714,29 decitex mas nao inferior a 232,56 decitex (numero metrico superior a 14 mas nao superior a 43);1;KG
5559;52061300;Fios simples de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43 mas nao superior a 52);1;KG
5560;52061400;Fios simples de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 192,31 decitex mas nao inferior a 125 decitex (numero metrico superior a 52 mas nao superior a 80);1;KG
5561;52061500;Fios simples de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo inferior a 125 decitex (numero metrico superior a 80);1;KG
5562;52062100;Fios simples de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo igual ou superior a 714,29 decitex (numero metrico nao superior a 14);1;KG
5563;52062200;Fios simples de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 714,29 decitex mas nao inferior a 232,56 decitex (numero metrico superior a 14 mas nao superior a 43);1;KG
5564;52062300;Fios simples de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43 mas nao superior a 52);1;KG
5565;52062400;Fios simples de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 192,31 decitex mas nao inferior a 125 decitex (numero metrico superior a 52 mas nao superior a 80);1;KG
5566;52062500;Fios simples de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo inferior a 125 decitex (numero metrico superior a 80);1;KG
5567;52063100;Fios retorcidos ou retorcidos multiplos de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo igual ou superior a 714,29 decitex (numero metrico nao superior a 14);1;KG
5568;52063200;Fios retorcidos ou retorcidos multiplos de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 714,29 decitex mas > 232,56 decitex (numero metrico >14 mas < 43);1;KG
5569;52063300;Fios retorcidos ou retorcidos multiplos de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 232,56 decitex mas > 192,31 decitex (numero metrico > 43 mas < 52);1;KG
5570;52063400;Fios retorcidos ou retorcidos multiplos de algodao,de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 192,31 decitex mas > 125 decitex (numero metrico > 52 mas nao superior a 80);1;KG
5571;52063500;Fios retorcidos ou retorcidos multiplos de algodao, de fibras nao penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo inferior a 125 decitex (numero metrico superior a 80);1;KG
5572;52064100;Fios retorcidos ou retorcidos multiplos de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo igual ou superior a 714,29 decitex (numero metrico nao superior a 14);1;KG
5573;52064200;Fios retorcidos ou retorcidos multiplos de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 714,29 decitex mas nao inferior a 232,56 decitex (numero metrico superior a 14;1;KG
5574;52064300;Fios retorcidos ou retorcidos multiplos de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 232,56 decitex mas nao inferior a 192,31 decitex (numero metrico superior a 43;1;KG
5575;52064400;Fios retorcidos ou retorcidos multiplos de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo < 192,31 decitex mas nao inferior a 125 decitex (numero metrico superior a 52 mas;1;KG
5576;52064500;Fios retorcidos ou retorcidos multiplos de algodao, de fibras penteadas, que contenham menos de 85 %, em peso, de algodao, nao acondicionados para venda a retalho, de titulo inferior a 125 decitex (numero metrico superior a 80);1;KG
5577;52071000;Fios de algodao (exceto linhas para costurar) acondicionados para venda a retalho, que contenham pelo menos 85 %, em peso, de algodao;1;KG
5578;52079000;Outros fios de algodao (exceto linhas para costurar) acondicionados para venda a retalho;1;KG
5579;52081100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, crus, em ponto de tafeta, com peso nao superior a 100 g/m2;1;KG
5580;52081200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, crus, em ponto de tafeta, com peso superior a 100 g/m2;1;KG
5581;52081300;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, crus, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5582;52081900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, crus;1;KG
5583;52082100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, branqueados, em ponto de tafeta, com peso nao superior a 100 g/m2;1;KG
5584;52082200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, branqueados, em ponto de tafeta, com peso superior a 100 g/m2;1;KG
5585;52082300;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, branqueados, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5586;52082900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, branqueados;1;KG
5587;52083100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, tintos, em ponto de tafeta, com peso nao superior a 100 g/m2;1;KG
5588;52083200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, tintos, em ponto de tafeta, com peso superior a 100 g/m2;1;KG
5589;52083300;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, tintos, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5590;52083900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, tintos;1;KG
5591;52084100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, de fios de diversas cores, em ponto de tafeta, com peso nao superior a 100 g/m2;1;KG
5592;52084200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, de fios de diversas cores, em ponto de tafeta, com peso superior a 100 g/m2;1;KG
5593;52084300;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, de fios de diversas cores, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5594;52084900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, de fios de diversas cores;1;KG
5595;52085100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, estampados, em ponto de tafeta, com peso nao superior a 100 g/m2;1;KG
5596;52085200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, estampados, em ponto de tafeta, com peso superior a 100 g/m2;1;KG
5597;52085910;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, estampados, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5598;52085990;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso nao superior a 200 g/m2, estampados;1;KG
5599;52091100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, crus, em ponto de tafeta;1;KG
5600;52091200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, crus, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5601;52091900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, crus;1;KG
5602;52092100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, branqueados, em ponto de tafeta;1;KG
5603;52092200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, branqueados, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5604;52092900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, branqueados;1;KG
5605;52093100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, tintos, em ponto de tafeta;1;KG
5606;52093200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, branqueados, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5607;52093900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, tintos;1;KG
5608;52094100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, de fios de diversas cores, em ponto de tafeta;1;KG
5609;52094210;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, denominados Denim, com fios tintos em indigo blue segundo Color Index 73.000;1;KG
5610;52094290;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, denominados Denim;1;KG
5611;52094300;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, de fios de diversas cores, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5612;52094900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, de fios de diversas cores;1;KG
5613;52095100;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, estampados, em ponto de tafeta;1;KG
5614;52095200;Tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, estampados, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5615;52095900;Outros tecidos de algodao que contenham pelo menos 85 %, em peso, de algodao, com peso superior a 200 g/m2, estampados;1;KG
5616;52101100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, crus, em ponto de tafeta;1;KG
5617;52101910;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, peso < 200 g/m2, crus, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5618;52101990;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, crus;1;KG
5619;52102100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, branqueados, em ponto de tafeta;1;KG
5620;52102910;Tecidos de algodao que contenham menos de 85 %,em peso,de algodao,combinados, principal ou unicamente, com fibras sinteticas ou artificiais, peso < 200 g/m2, branqueados,em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5621;52102990;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, branqueados;1;KG
5622;52103100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, tintos, em ponto de tafeta;1;KG
5623;52103200;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, peso < 200 g/m2, tintos, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5624;52103900;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, tintos;1;KG
5625;52104100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, de fios de diversas cores, em ponto de tafeta;1;KG
5626;52104910;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas/artificiais, p < 200 g/m2, de fios de diversas cores, em ponto sarjado, incluindo o diagonal, cuja relacao de textura < 4;1;KG
5627;52104990;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, de fios de diversas cores;1;KG
5628;52105100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, estampados, em ponto de tafeta;1;KG
5629;52105910;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados,principal ou unicamente, com fibras sinteticas ou artificiais, peso < 200 g/m2, estampados,em ponto sarjado,incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5630;52105990;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso nao superior a 200 g/m2, estampados;1;KG
5631;52111100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, crus, em ponto de tafeta;1;KG
5632;52111200;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, peso > 200 g/m2, crus, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5633;52111900;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, crus;1;KG
5634;52112010;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, branqueados, em ponto de tafeta;1;KG
5635;52112020;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, branqueados, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao;1;KG
5636;52112090;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, branqueados;1;KG
5637;52113100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, tintos, em ponto de tafeta;1;KG
5638;52113200;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, peso > 200 g/m2, tintos, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5639;52113900;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, tintos;1;KG
5640;52114100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, de fios de diversas cores, em ponto de tafeta;1;KG
5641;52114210;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, com fios tintos em indigo blue segundo Color Index 73.000;1;KG
5642;52114290;Outros tecidos de algodao denominados Denim, que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, de fios de diversas cores;1;KG
5643;52114300;Outros tecidos de algodao em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2;1;KG
5644;52114900;Outros tecidos de algodao, que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2;1;KG
5645;52115100;Tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, estampados, em ponto de tafeta;1;KG
5646;52115200;Tecidos de algodao que contenham menos de 85 %,em peso, de algodao,combinados, principal ou unicamente, com fibras sinteticas ou artificiais, peso > 200 g/m2, estampados,em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5647;52115900;Outros tecidos de algodao que contenham menos de 85 %, em peso, de algodao, combinados, principal ou unicamente, com fibras sinteticas ou artificiais, com peso superior a 200 g/m2, estampados;1;KG
5648;52121100;Outros tecidos de algodao, com peso nao superior a 200 g/m2, crus;1;KG
5649;52121200;Outros tecidos de algodao, com peso nao superior a 200 g/m2, branqueados;1;KG
5650;52121300;Outros tecidos de algodao, com peso nao superior a 200 g/m2, tintos;1;KG
5651;52121400;Outros tecidos de algodao, com peso nao superior a 200 g/m2, de fios de diversas cores;1;KG
5652;52121500;Outros tecidos de algodao, com peso nao superior a 200 g/m2, estampados;1;KG
5653;52122100;Outros tecidos de algodao, com peso superior a 200 g/m2, crus;1;KG
5654;52122200;Outros tecidos de algodao, com peso superior a 200 g/m2, branqueados;1;KG
5655;52122300;Outros tecidos de algodao, com peso superior a 200 g/m2, tintos;1;KG
5656;52122400;Outros tecidos de algodao, com peso superior a 200 g/m2, de fios de diversas cores;1;KG
5657;52122500;Outros tecidos de algodao, com peso superior a 200 g/m2, estampados;1;KG
5658;53011000;Linho em bruto ou macerado;1;KG
5659;53012110;Linho quebrado;1;KG
5660;53012120;Linho espadelado, mas nao fiado;1;KG
5661;53012910;Linho penteado, mas nao fiado;1;KG
5662;53012990;Linho trabalhado de outra forma, mas nao fiado;1;KG
5663;53013000;Estopas e desperdicios de linho;1;KG
5664;53021000;Canhamo em bruto ou macerado;1;KG
5665;53029000;Canhamo trabalhado de outra forma, mas nao fiado, estopas, desperdicios;1;KG
5666;53031010;Juta;1;KG
5667;53031090;Outras fibras texteis liberianas, em bruto ou maceradas;1;KG
5668;53039010;Juta trabalhada de outro modo, mas nao fiada, estopas, desperdicios;1;KG
5669;53039090;Outras fibras texteis liberianas trabalhadas de outro modo, estopas, etc.;1;KG
5670;53050010;Abaca (canhamo de manilha) em bruto;1;KG
5671;53050090;Outras fibras texteis vegetais, estopas, desperdicios trabalhados;1;KG
5672;53061000;Fios de linho, simples;1;KG
5673;53062000;Fios de linho, retorcidos ou retorcidos multiplos;1;KG
5674;53071010;Fios de juta, simples;1;KG
5675;53071090;Fios de outras fibras texteis liberianas, simples;1;KG
5676;53072010;Fios de juta, retorcidos ou retorcidos multiplos;1;KG
5677;53072090;Fios de outras fibras texteis liberianas, retorcidos ou retorcidos multiplos;1;KG
5678;53081000;Fios de cairo (fios de fibras de coco);1;KG
5679;53082000;Fios de canhamo;1;KG
5680;53089000;Fios de outras fibras texteis vegetais;1;KG
5681;53091100;Tecidos de linho, que contenham pelo menos 85 %, em peso, de linho, crus ou branqueados;1;KG
5682;53091900;Outros tecidos de linho, que contenham pelo menos 85 %, em peso, de linho;1;KG
5683;53092100;Tecidos de linho, que contenham menos de 85 %, em peso, de linho, crus ou branqueados;1;KG
5684;53092900;Outros tecidos de linho, que contenham menos de 85 %, em peso, de linho;1;KG
5685;53101010;Tecidos de aniagem de juta, crus;1;KG
5686;53101090;Tecidos de outras fibras texteis liberianas, crus;1;KG
5687;53109000;Outros tecidos de juta ou outras fibras texteis liberianas;1;KG
5688;53110000;Tecidos de outras fibras texteis vegetais, tecidos de fios de papel;1;KG
5689;54011011;Linhas para costurar, de poliester, nao acondicionadas para venda a retalho;1;KG
5690;54011012;Linhas para costurar, de poliester, acondicionadas para venda a retalho;1;KG
5691;54011090;Linhas para costurar, de outros filamentos sinteticos;1;KG
5692;54012011;Linhas para costurar, de raiom viscose, de alta tenacidade, nao acondicionadas para venda a retalho;1;KG
5693;54012012;Linhas para costurar, de raiom viscose, de alta tenacidade, acondicionadas para venda a retalho;1;KG
5694;54012090;Linhas para costurar, de outros filamentos artificiais;1;KG
5695;54021100;Fios de alta tenacidade, de aramidas;1;KG
5696;54021910;Fios de alta tenacidade, de nailon;1;KG
5697;54021990;Fio de alta tenacidade, de outras poliamidas;1;KG
5698;54022000;Fio de alta tenacidade, de poliesteres;1;KG
5699;54023111;Fios texturizados, de nailon, tintos, de titulo igual ou inferior a 50 tex por fio simples;1;KG
5700;54023119;Outros fios texturizados, de nailon, de titulo igual ou inferior a 50 tex por fio simples;1;KG
5701;54023190;Fio texturizado, de outras poliamidas, tinto, de titulo igual ou inferior a 50 tex por fio simples;1;KG
5702;54023211;Multifilamento com efeito antiestatico permanente, de titulo superior a 110 tex;1;KG
5703;54023219;Outros fios texturizados, de nailon, de titulo superior a 50 tex por fio simples;1;KG
5704;54023290;Fios texturizados de outras poliamidas, de titulo superior a 50 tex por fio simples;1;KG
5705;54023310;Fios texturizados de poliesteres, crus;1;KG
5706;54023320;Fios texturizados de poliesteres, tintos;1;KG
5707;54023390;Outros fios texturizados de poliesteres;1;KG
5708;54023400;Multifilamento de polipropileno, titulo > 110 tex;1;KG
5709;54023900;Outros fios texturizados;1;KG
5710;54024400;Outros fios, simples, sem torcao ou com torcao nao superior a 50 voltas por metro, de elastomeros;1;KG
5711;54024510;Fio simples de aramidas, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5712;54024520;Fios simples de nailon, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5713;54024590;Fios simples outros poliesteres, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5714;54024600;Outros fios simples de poliesteres, parcialmente orientados, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5715;54024710;Outros fios simples de poliesteres, crus, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5716;54024720;Outros fios simples de poliesteres, tintos, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5717;54024790;Outros fios simples de poliesteres, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5718;54024800;Fios simples de outros polipropilenos, sem torcao ou com torcao nao superior a 50 voltas por metro;1;KG
5719;54024910;Outros fios simples de polietileno, sem torcao ou com torcao nao superior a 50 voltas por metro, com tenacidade superior ou igual a 26 cN/tex;1;KG
5720;54024990;Fio de outros filamentos sinteticos simples, com torcao superior a 50 voltas por metro;1;KG
5721;54025110;Fio de aramida, simples, com torcao superior a 50 voltas por metro;1;KG
5722;54025190;Fio de nailon/outras poliamidas, simples, com torcao superior a 50 voltas por metro;1;KG
5723;54025200;Fio de poliesteres, simples, com torcao superior a 50 voltas por metro;1;KG
5724;54025300;Outros fios, simples, com torcao superior a 50 voltas por metro, de polipropileno;1;KG
5725;54025900;Fio de outros filamentos sinteticos simples, com torcao superior a 50 voltas por metro;1;KG
5726;54026110;Fio de aramida, retorcido ou retorcido multiplo;1;KG
5727;54026190;Fio de nailon/outras poliamidas, retorcido/retorcido multiplo;1;KG
5728;54026200;Fios de poliesteres, retorcido ou retorcido multiplo;1;KG
5729;54026300;Outros fios, retorcidos ou retorcidos multiplos, de polipropileno;1;KG
5730;54026900;Fios de outros filamentos sinteticos, retorcido/retorcido multiplo;1;KG
5731;54031000;Fio de alta tenacidade, de raiom viscose;1;KG
5732;54033100;Fio de raiom viscose, sem torcao ou com torcao nao superior a 120 voltas por metro;1;KG
5733;54033200;Fio de raiom viscose, com torcao superior a 120 voltas por metro;1;KG
5734;54033300;Fio de acetato de celulose, simples;1;KG
5735;54033900;Fio de outros filamentos artificiais, simples;1;KG
5736;54034100;Fio de raiom viscose, retorcido ou retorcido multiplo;1;KG
5737;54034200;Fio de acetato de celulose, retorcido ou retorcido multiplo;1;KG
5738;54034900;Fio de outros filamentos artificiais, retorcidos/retorcido multiplo;1;KG
5739;54041100;Monofilamentos de elastomeros, cuja largura aparente nao seja superior a 5 mm;1;KG
5740;54041200;Outros monofilamentos de polipropileno, cuja largura aparente nao seja superior a 5 mm;1;KG
5741;54041911;Imitacoes de categute, reabsorviveis;1;KG
5742;54041919;Outras imitacoes de categute, de monofilamentos;1;KG
5743;54041990;Outros monofilamentos sinteticos, cuja largura aparente nao seja superior a 5 mm;1;KG
5744;54049000;Laminas de materias texteis sinteticas, cuja largura aparente nao seja superior a 5 mm;1;KG
5745;54050000;Monofilamentos artificiais, de titulo >=67 decitex e cuja maior dimensao da secao transversal nao seja superior a 1 mm, laminas e formas semelhantes (palha artificial, por exemplo) de materias texteis artificiais, com largura aparente <= 5 mm;1;KG
5746;54060010;Fios de filamentos sinteticos (exceto linhas para costurar), acondicionados para venda a retalho;1;KG
5747;54060020;Fios de filamentos artificiais (exceto linhas para costurar), acondicionados para venda a retalho;1;KG
5748;54071011;Tecidos obtidos a partir de fios de alta tenacidade, de aramida, sem fios de borracha;1;KG
5749;54071019;Outros tecidos obtidos a partir de fios de alta tenacidade, de nailon ou de outras poliamidas ou de poliesteres, sem fios de borracha;1;KG
5750;54071021;Tecidos obtidos a partir de fios de alta tenacidade, de aramidas, com fios de borracha;1;KG
5751;54071029;Outros tecidos obtidos a partir de fios de alta tenacidade, de nailon ou de outras poliamidas ou de poliesteres, com fios de borracha;1;KG
5752;54072000;Tecidos obtidos a partir de laminas ou de formas semelhantes;1;KG
5753;54073000;Tecidos mantas de fios de filamento sintetico (Tecidos mencionados na Nota 9 da Secao XI);1;KG
5754;54074100;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de nailon ou de outras poliamidas, crus ou branqueados;1;KG
5755;54074200;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de nailon ou de outras poliamidas, tintos;1;KG
5756;54074300;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de nailon ou de outras poliamidas, de fios de diversas cores;1;KG
5757;54074400;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de nailon ou de outras poliamidas, estampados;1;KG
5758;54075100;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de poliester texturizados, crus ou branqueados;1;KG
5759;54075210;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de poliester texturizados, tintos, sem fios de borracha;1;KG
5760;54075220;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de poliester texturizados, tintos, com fios de borracha;1;KG
5761;54075300;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de poliester texturizados, de fios de diversas cores;1;KG
5762;54075400;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de poliester texturizados, estampados;1;KG
5763;54076100;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos de poliester nao texturizados;1;KG
5764;54076900;Tecido de outros filamentos de poliester que contenham pelo menos 85 %, em peso, de filamentos sinteticos;1;KG
5765;54077100;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos sinteticos, crus ou branqueados;1;KG
5766;54077200;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos sinteticos, tintos;1;KG
5767;54077300;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos sinteticos, de fios de diversas cores;1;KG
5768;54077400;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos sinteticos, estampados;1;KG
5769;54078100;Outros tecidos, que contenham menos de 85 %, em peso, de filamentos sinteticos, combinados, principal ou unicamente, com algodao, crus ou branqueados;1;KG
5770;54078200;Outros tecidos, que contenham menos de 85 %, em peso, de filamentos sinteticos, combinados, principal ou unicamente, com algodao, tintos;1;KG
5771;54078300;Outros tecidos, que contenham menos de 85 %, em peso, de filamentos sinteticos, combinados, principal ou unicamente, com algodao, de fios de diversas cores;1;KG
5772;54078400;Outros tecidos, que contenham menos de 85 %, em peso, de filamentos sinteticos, combinados, principal ou unicamente, com algodao, estampados;1;KG
5773;54079100;Outros tecidos de filamentos sinteticos, crus ou branqueados;1;KG
5774;54079200;Outros tecidos de filamentos sinteticos, tintos;1;KG
5775;54079300;Outros tecidos de filamentos sinteticos, de fios de diversas cores;1;KG
5776;54079400;Outros tecidos de filamentos sinteticos, estampados;1;KG
5777;54081000;Tecidos obtidos a partir de fios de alta tenacidade, de raiom viscose;1;KG
5778;54082100;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos ou de laminas ou formas semelhantes, artificiais, crus ou branqueados;1;KG
5779;54082200;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos ou de laminas ou formas semelhantes, artificiais, tintos;1;KG
5780;54082300;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos ou de laminas ou formas semelhantes, artificiais, de fios de diversas cores;1;KG
5781;54082400;Outros tecidos, que contenham pelo menos 85 %, em peso, de filamentos ou de laminas ou formas semelhantes, artificiais, estampados;1;KG
5782;54083100;Outros tecidos de filamentos artificiais, crus ou branqueados;1;KG
5783;54083200;Outros tecidos de filamentos artificiais, tintos;1;KG
5784;54083300;Outros tecidos de filamentos artificiais, de fios de diversas cores;1;KG
5785;54083400;Outros tecidos de filamentos artificiais, estampados;1;KG
5786;55011000;Cabos de nailon ou de outras poliamidas;1;KG
5787;55012000;Cabos de poliesteres;1;KG
5788;55013000;Cabos acrilicos ou modacrilicos;1;KG
5789;55014000;Cabos de filamentos sinteticos de polipropileno;1;KG
5790;55019000;Cabos de outros filamentos sinteticos;1;KG
5791;55021000;Cabos de filamentos artificiais, de acetato de celulose;1;KG
5792;55029010;Cabos de filamentos artificiais, de raiom viscose;1;KG
5793;55029090;Outros cabos de filamentos artificiais;1;KG
5794;55031100;Fibras sinteticas descontinuas, de aramida, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5795;55031910;Fibras sinteticas descontinuas bicomponentes, de diferentes pontos de fusao;1;KG
5796;55031990;Fibras de nailon e outras poliamidas, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5797;55032010;Fibras de poliesteres bicomponentes, de diferentes pontos de fusao;1;KG
5798;55032090;Outras fibras de poliesteres, descontinuas, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5799;55033000;Fibras acrilicas ou modacrilicas, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5800;55034000;Fibras de polipropileno, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5801;55039010;Outras fibras bicomponentes, de diferentes pontos de fusao, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5802;55039020;Fibras de poli(alcool vinilico) nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5803;55039090;Outras fibras sinteticas descontinuas, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5804;55041000;Fibras de raiom viscose, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5805;55049010;Fibras artificiais descontinuas, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao, de liocel;1;KG
5806;55049090;Outras fibras artificiais descontinuas, nao cardadas, nao penteadas nem transformadas de outro modo para fiacao;1;KG
5807;55051000;Desperdicios de fibras sinteticas (incluindo os desperdicios da penteacao, os de fios e os fiapos);1;KG
5808;55052000;Desperdicios de fibras artificiais (incluindo os desperdicios da penteacao, os de fios e os fiapos);1;KG
5809;55061000;Fibras sinteticas descontinuas, cardadas, penteadas ou transformadas de outro modo para fiacao, de nailon ou de outras poliamidas;1;KG
5810;55062000;Fibras sinteticas descontinuas, cardadas, penteadas ou transformadas de outro modo para fiacao, de poliesteres;1;KG
5811;55063000;Fibras acrilicas ou modacrilicas, cardadas, penteadas ou transformadas de outro modo para fiacao;1;KG
5812;55064000;Fibras sinteticas descontinuas, cardadas, penteadas ou transformadas de outro modo para fiacao, de polipropileno;1;KG
5813;55069000;Outras fibras sinteticas descontinuas, cardadas, penteadas ou transformadas de outro modo para fiacao;1;KG
5814;55070000;Fibras artificiais descontinuas, cardadas, penteadas ou transformadas de outro modo para fiacao;1;KG
5815;55081000;Linhas para costurar, de fibras sinteticas descontinuas, mesmo acondicionadas para venda a retalho;1;KG
5816;55082000;Linhas para costurar, de fibras artificiais descontinuas, mesmo acondicionadas para venda a retalho;1;KG
5817;55091100;Fio que contenham pelo menos 85 %, em peso, de fibras descontinuas de nailon ou de outras poliamidas, simples;1;KG
5818;55091210;Fio de retorcidos ou retorcidos multiploes, que contenham pelo menos 85 %, em peso, de aramidas;1;KG
5819;55091290;Fio de fibras de nailon/outras poliamidas >= 85%, retorcido, etc;1;KG
5820;55092100;Fio de fibras de poliesteres >= 85%, simples;1;KG
5821;55092200;Fio de fibras de poliesteres >= 85%, retorcido/retorcido multiplo;1;KG
5822;55093100;Fio de fibras acrilicas/modacrilicas >= 85%, simples;1;KG
5823;55093200;Fio de fibras acrilicas/modacrilicas >= 85%, retorcido,  etc;1;KG
5824;55094100;Fio de outras fibras sinteticas >= 85%, simples;1;KG
5825;55094200;Fio de outras fibras sinteticas >=85%, retorcido/retorcido multiplo;1;KG
5826;55095100;Fio de fibras de poliesteres, combinadas, principal ou unicamente, com fibras artificiais descontinuas;1;KG
5827;55095200;Fio de fibras de poliesteres, combinadas, principal ou unicamente, com la ou pelos finos;1;KG
5828;55095300;Fio de fibras de poliesteres, combinadas, principal ou unicamente, com algodao;1;KG
5829;55095900;Outros fios de fibras de poliesteres;1;KG
5830;55096100;Fio de fibras acrilicas ou modacrilicas, combinadas, principal ou unicamente, com la ou pelos finos;1;KG
5831;55096200;Fio de fibras acrilicas ou modacrilicas, combinadas, principal ou unicamente, com algodao;1;KG
5832;55096900;Outros fios de fibras acrilicas ou modacrilicas;1;KG
5833;55099100;Fio de outras fibras sinteticas, combinados, principal ou unicamente, com la ou pelos finos;1;KG
5834;55099200;Fio de outras fibras sinteticas, combinados, principal ou unicamente, com algodao;1;KG
5835;55099900;Outros fios de fibras sinteticas;1;KG
5836;55101111;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, simples, obtidos a partir de fibras de celulose, de raiom viscose, exceto modal;1;KG
5837;55101112;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, simples, obtidos a partir de fibras de celulose, de modal;1;KG
5838;55101113;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, obtidos a partir de fibras de celulose, simples, de liocel;1;KG
5839;55101119;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, simples, obtidos a partir de fibras de celulose, de outros materiais;1;KG
5840;55101190;Outros fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, simples;1;KG
5841;55101211;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, retorcidos ou retorcidos multiplos, obtidos a partir de fibras de celulose, de raiom viscose, exceto modal;1;KG
5842;55101212;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, retorcidos ou retorcidos multiplos, obtidos a partir de fibras de celulose, de modal;1;KG
5843;55101213;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, retorcidos ou retorcidos multiplos, obtidos a partir de fibras de celulose, de liocel;1;KG
5844;55101219;Fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, retorcidos ou retorcidos multiplos, obtidos a partir de fibras de celulose, de outros materiais;1;KG
5845;55101290;Outros fios que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, retorcidos ou retorcidos multiplos;1;KG
5846;55102011;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com la ou pelos finos, obtidos a partir de fibras de celulose, de raiom viscose, exceto modal;1;KG
5847;55102012;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com la ou pelos finos, obtidos a partir de fibras de celulose, de modal;1;KG
5848;55102013;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com la ou pelos finos, obtidos a partir de fibras de celulose, de liocel;1;KG
5849;55102019;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com la ou pelos finos, obtidos a partir de fibras de celulose, de outros materiais;1;KG
5850;55102090;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com la ou pelos finos, obtidos a partir de fibras que nao sejam de celulose;1;KG
5851;55103011;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com algodao, obtidos a partir de fibras de celulose, de raiom viscose, exceto modal;1;KG
5852;55103012;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com algodao, obtidos a partir de fibras de celulose, de modal;1;KG
5853;55103013;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com algodao, obtidos a partir de fibras de celulose, de liocel;1;KG
5854;55103019;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com algodao, obtidos a partir de fibras de celulose, de outros materiais;1;KG
5855;55103090;Outros fios de fibras artificiais descontinuas, combinados, principal ou unicamente, com algodao, obtidos a partir de fibras que nao sejam de celulose;1;KG
5856;55109011;Outros fios de fibras artificiais descontinuas, obtidos a partir de fibras de celulose, de raiom viscose, exceto modal;1;KG
5857;55109012;Outros fios de fibras artificiais descontinuas, obtidos a partir de fibras de celulose, de modal;1;KG
5858;55109013;Outros fios de fibras artificiais descontinuas, obtidos a partir de fibras de celulose, de liocel;1;KG
5859;55109019;Outros fios de fibras artificiais descontinuas, obtidos a partir de fibras de celulose, de outros materiais;1;KG
5860;55109090;Outros fios de fibras artificiais descontinuas, obtidos a partir de fibras que nao sejam de celulose;1;KG
5861;55111000;Fios de fibras sinteticas descontinuas, que contenham pelo menos 85 %, em peso, destas fibras, acondicionados para venda a retalho;1;KG
5862;55112000;Fios de fibras sinteticas descontinuas, que contenham menos de 85 %, em peso, destas fibras, acondicionados para venda a retalho;1;KG
5863;55113000;Fios de fibras artificiais descontinuas, acondicionados para venda a retalho;1;KG
5864;55121100;Tecidos que contenham pelo menos 85 %, em peso, de fibras descontinuas de poliester, crus ou branqueados;1;KG
5865;55121900;Outros tecidos que contenham pelo menos 85 %, em peso, de fibras descontinuas de poliester;1;KG
5866;55122100;Tecidos que contenham pelo menos 85 %, em peso, de fibras descontinuas acrilicas ou modacrilicas, crus ou branqueados;1;KG
5867;55122900;Outros tecidos que contenham pelo menos 85 %, em peso, de fibras descontinuas acrilicas ou modacrilicas;1;KG
5868;55129110;Tecido de fibras de aramida, crus ou branqueados;1;KG
5869;55129190;Outros tecidos de outras fibras sinteticas descontinuas,  crus ou branqueados;1;KG
5870;55129910;Outros tecidos de fibras de aramida >= 85%;1;KG
5871;55129990;Outros tecidos de fibras sinteticas descontinuas >= 85%;1;KG
5872;55131100;Tecido de fibras descontinuas de poliester < 85%, em ponto de tafeta, com algodao, peso <= 170 g/m2, cru/branqueado;1;KG
5873;55131200;Tecido de poliester < 85% com algodao, peso <= 170 g/m2,  sarjado, cru/branqueado;1;KG
5874;55131300;Outros tecidos de poliester < 85% com algodao, peso <= 170 g/m2, cru/branqueado;1;KG
5875;55131900;Outros tecidos de fibra sintetica < 85% com algodao, peso <= 170 g/m2, cru/branqueado;1;KG
5876;55132100;Tecido de poliester < 85% com algodao,  peso <= 170g/m2, tafeta, tinto;1;KG
5877;55132310;Outros tecidos de fibras descontinuas de poliester, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4, tintos;1;KG
5878;55132390;Outros tecidos de fibras descontinuas de poliester, tintos;1;KG
5879;55132900;Outros tecidos de fibra sintetica < 85% com algodao, peso <= 170 g/m2, tintos;1;KG
5880;55133100;Tecido poliester < 85% com algodao, peso <= 170 g/m2, tafeta, diversas cores;1;KG
5881;55133911;Tecido de fios de diversas cores de fibras descontinuas de poliester < 85%, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4, peso <= 170 g/m2;1;KG
5882;55133919;Tecido de fios de diversas cores de fibras descontinuas de poliester < 85%, peso <= 170 g/m2;1;KG
5883;55133990;Outros tecidos < 85% de fibras descontinuas sinteticas combinadas com algo;1;KG
5884;55134100;Tecido de poliester < 85% com algodao, peso <= 170 g/m2,  tafeta, estampado;1;KG
5885;55134911;Tecido estampado < 85% fibras descontinuas de poliester, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5886;55134919;Outros tecidos < 85% de fibras descontinuas de poliester combinada com algodao;1;KG
5887;55134990;Outros tecidos < 85% de fibras descontinuas sinteticas combinadas com algodao;1;KG
5888;55141100;Tecido de fibras descontinuas de poliester, que contenham menos de 85 %, em peso, destas fibras, combinados, principal ou unicamente, com algodao, de peso superior a 170 g/m2, em ponto de tafeta;1;KG
5889;55141200;Tecido de fibras descontinuas de poliester, que contenham menos de 85 %, em peso, destas fibras, combinados, principal ou unicamente, com algodao, de peso > 170 g/m2, em ponto sarjado, incluindo o diagonal, cuja relacao de textura nao seja superior a 4;1;KG
5890;55141910;Outros tecidos < 85% fibra descontinuas poliester, cru/branqueado, com algo;1;KG
5891;55141990;Outros tecidos < 85% fibra sintetica descontinua cru/branqueado, com algodao;1;KG
5892;55142100;Tecido de poliester < 85% com algodao, peso > 170 g/m2, tafeta, tinto;1;KG
5893;55142200;Tecido de poliester < 85% com algodao, peso > 170 g/m2,  sarjado, tinto;1;KG
5894;55142300;Outros tecidos de poliester < 85% com algodao,  peso > 170 g/m2, tintos;1;KG
5895;55142900;Outros tecidos de fibra sintetica < 85% com algodao, peso > 170 g/m2, tintos;1;KG
5896;55143011;Tecidos < 85% fibra descontinua de poliester, tafeta, combinado com algodao;1;KG
5897;55143012;Tecido < 85% fibras descontinuas, fios de diversas cores, com algodao, ponto sarjado;1;KG
5898;55143019;Outros tecidos < 85% fibras descontinuas de poliester, fios de diversas cores, com algodao;1;KG
5899;55143090;Outros tecidos < 85% fibras descontinuas sinteticas, fios de diversas cores, com algodao;1;KG
5900;55144100;Tecido de poliester < 85% com algodao, peso > 170 g/m2, tafeta,  estampado;1;KG
5901;55144200;Tecido de poliester < 85% com algodao, peso > 170 g/m2, sarjado,  estampado;1;KG
5902;55144300;Outros tecidos de poliester < 85% com algodao, peso > 170 g/m2,  estampados;1;KG
5903;55144900;Outros tecidos de fibra sintetica < 85% com algodao, peso > 170 g/m2, estampado;1;KG
5904;55151100;Tecido de fibras descontinuas de poliester, combinadas, principal ou unicamente, com fibras descontinuas de raiom viscose;1;KG
5905;55151200;Tecido de fibras descontinuas de poliester, combinadas, principal ou unicamente, com filamentos sinteticos ou artificiais;1;KG
5906;55151300;Tecido de fibras descontinuas de poliester, combinadas, principal ou unicamente, com la ou pelos finos;1;KG
5907;55151900;Outros tecidos de fibras descontinuas de poliester;1;KG
5908;55152100;Tecido de fibras descontinuas acrilicas ou modacrilicas, combinadas, principal ou unicamente, com filamentos sinteticos ou artificiais;1;KG
5909;55152200;Tecido de fibras descontinuas acrilicas ou modacrilicas, combinadas, principal ou unicamente, com la ou pelos finos;1;KG
5910;55152900;Outros tecidos de fibras descontinuas acrilicas ou modacrilicas;1;KG
5911;55159100;Outros tecidos de fibras sinteticas descontinuas, combinados, principal ou unicamente, com filamentos sinteticos ou artificiais;1;KG
5912;55159910;Outros tecidos de fibras sinteticas descontinuas, combinados, principal ou unicamente, com la ou pelos finos;1;KG
5913;55159990;Outros tecidos de fibras sinteticas descontinuas;1;KG
5914;55161100;Tecidos que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, crus ou branqueados;1;KG
5915;55161200;Tecidos que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, tintos;1;KG
5916;55161300;Tecidos que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, de fios de diversas cores;1;KG
5917;55161400;Tecidos que contenham pelo menos 85 %, em peso, de fibras artificiais descontinuas, estampados;1;KG
5918;55162100;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com filamentos sinteticos ou artificiais, crus ou branqueados;1;KG
5919;55162200;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com filamentos sinteticos ou artificiais, tintos;1;KG
5920;55162300;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com filamentos sinteticos ou artificiais, de fios de diversas cores;1;KG
5921;55162400;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com filamentos sinteticos ou artificiais, estampados;1;KG
5922;55163100;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com la ou pelos finos, crus ou branqueados;1;KG
5923;55163200;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com la ou pelos finos, tintos;1;KG
5924;55163300;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com la ou pelos finos, de fios de diversas cores;1;KG
5925;55163400;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com la ou pelos finos, estampados;1;KG
5926;55164100;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com algodao, crus ou branqueados;1;KG
5927;55164200;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com algodao, tintos;1;KG
5928;55164300;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com algodao, de fios de diversas cores;1;KG
5929;55164400;Tecidos que contenham menos de 85 %, em peso, de fibras artificiais descontinuas, combinadas, principal ou unicamente, com algodao, estampados;1;KG
5930;55169100;Outros tecidos de fibras artificiais descontinuas, crus ou branqueados;1;KG
5931;55169200;Outros tecidos de fibras artificiais descontinuas, tintos;1;KG
5932;55169300;Outros tecidos de fibras artificiais descontinuas, de fios de diversas cores;1;KG
5933;55169400;Outros tecidos de fibras artificiais descontinuas, estampados;1;KG
5934;56012110;Pastas (ouates) de algodao;1;KG
5935;56012190;Outros artigos de pastas (ouates) de algodao;1;KG
5936;56012211;Pastas (ouates) de fibras de aramida;1;KG
5937;56012219;Pastas (ouates) de outras fibras sinteticas ou artificiais;1;KG
5938;56012291;Cilindros para filtros de cigarros, de pastas fibras sinteticas ou artificiais;1;KG
5939;56012299;Outros artigos de pastas de fibras sinteticas ou artificiais;1;KG
5940;56012900;Pastas/outros artigos de pastas, de outras materias texteis;1;KG
5941;56013010;Tontisses, nos e bolotas de materias texteis, de aramida;1;KG
5942;56013090;Tontisses, nos e bolotas, de outras materias texteis;1;KG
5943;56021000;Feltros agulhados e artefatos obtidos por costura por entrelacamento (cousus-tricotes);1;KG
5944;56022100;Outros feltros, nao impregnados, nem revestidos, nem recobertos, nem estratificados, de la ou de pelos finos;1;KG
5945;56022900;Outros feltros, nao impregnados, nem revestidos, nem recobertos, nem estratificados, de outras materias texteis;1;KG
5946;56029000;Outros feltros, mesmo impregnados, revestidos, recobertos ou estratificados;1;KG
5947;56031110;Falsos tecidos de aramida, mesmo impregnados, revestidos, recobertos ou estratificados, de peso nao superior a 25 g/m2;1;KG
5948;56031120;Falsos tecidos de poliester, mesmo impregnados, revestidos, recobertos ou estratificados, de peso nao superior a 25 g/m2;1;KG
5949;56031130;Falsos tecidos de polipropileno, mesmo impregnados, revestidos, recobertos ou estratificados, de peso nao superior a 25 g/m2;1;KG
5950;56031140;Falsos tecidos de raiom viscose, mesmo impregnados, revestidos, recobertos ou estratificados, de peso nao superior a 25 g/m2;1;KG
5951;56031190;Falsos tecidos de outros filamentos sinteticos ou artificiais, de peso nao superior a 25 g/m2;1;KG
5952;56031210;Falsos tecidos de filamento de polietileno de alta densidade, de peso superior a 25 g/m2, mas nao superior a 70 g/m2;1;KG
5953;56031220;Falsos tecidos de filamentos de aramida, de peso superior a 25 g/m2, mas nao superior a 70 g/m2;1;KG
5954;56031230;Falsos tecidos de poliester, de peso superior a 25 g/m2, mas nao superior a 70 g/m2;1;KG
5955;56031240;Falsos tecidos de polipropileno, de peso superior a 25 g/m2, mas nao superior a 70 g/m2;1;KG
5956;56031250;Falsos tecidos de raiom viscose, de peso superior a 25 g/m2, mas nao superior a 70 g/m2;1;KG
5957;56031290;Falsos tecidos de outros filamentos sinteticos ou artificiais, de peso superior a 25 g/m2, mas nao superior a 70 g/m2;1;KG
5958;56031310;Falsos tecidos de filamento de polietileno alta densidade, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5959;56031320;Falsos tecidos de filamentos de aramida, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5960;56031330;Falsos tecidos de poliester, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5961;56031340;Falsos tecidos de polipropileno, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5962;56031350;Falsos tecidos de raiom viscose, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5963;56031390;Falsos tecidos de outros filamentos sinteticos/artificiais, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5964;56031410;Falsos tecidos de filamentos de aramida, de peso superior a 150 g/m2;1;KG
5965;56031420;Falsos tecidos de poliester, de peso superior a 150 g/m2;1;KG
5966;56031430;Falsos tecidos de polipropileno, de peso superior a 150 g/m2;1;KG
5967;56031440;Falsos tecidos de raiom viscose, de peso superior a 150 g/m2;1;KG
5968;56031490;Falsos tecidos de outros filamentos sinteticos ou artificiais, de peso superior a 150 g/m2;1;KG
5969;56039110;Outros falsos tecidos de poliester, de peso nao superior a 25 g/m2;1;KG
5970;56039120;Outros falsos tecidos de polipropileno, de peso nao superior a 25 g/m2;1;KG
5971;56039130;Outros falsos tecidos de raiom viscose, de peso nao superior a 25 g/m2;1;KG
5972;56039190;Outros falsos tecidos, de peso nao superior a 25 g/m2;1;KG
5973;56039210;Outros falsos tecidos de polietileno de alta densidade, de peso superior a 25 g/m2 mas nao superior a 70 g/m2;1;KG
5974;56039220;Outros falsos tecidos de poliester, de peso superior a 25 g/m2 mas nao superior a 70 g/m2;1;KG
5975;56039230;Outros falsos tecidos de polipropileno, de peso superior a 25 g/m2 mas nao superior a 70 g/m2;1;KG
5976;56039240;Outros falsos tecidos de raiom viscose, de peso superior a 25 g/m2 mas nao superior a 70 g/m2;1;KG
5977;56039290;Outros falsos tecidos, de peso superior a 25 g/m2 mas nao superior a 70 g/m2;1;KG
5978;56039310;Outros falsos tecidos de polietileno de alta densidade, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5979;56039320;Outros falsos tecidos de poliester, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5980;56039330;Outros falsos tecidos de polipropileno, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5981;56039340;Outros falsos tecidos raiom viscose, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5982;56039390;Outros falsos tecidos, de peso superior a 70 g/m2 mas nao superior a 150 g/m2;1;KG
5983;56039410;Outros falsos tecidos de poliester, de peso superior a 150 g/m2;1;KG
5984;56039420;Outros falsos tecidos de polipropileno, de peso superior a 150 g/m2;1;KG
5985;56039430;Outros falsos tecidos de raiom viscose, de peso superior a 150 g/m2;1;KG
5986;56039490;Outros falsos tecidos, de peso superior a 150 g/m2;1;KG
5987;56041000;Fios e cordas, de borracha, recobertos de texteis;1;KG
5988;56049010;Imitacoes de categute constituidas por fios de seda;1;KG
5989;56049021;Fios de alta tenacidade, de poliesteres, nailon ou de outras poliamidas, ou de raiom viscose, impregnados ou revestidos, com borracha;1;KG
5990;56049022;Fios de alta tenacidade, de poliesteres, nailon ou de outras poliamidas, ou de raiom viscose, impregnados ou revestidos, com plastico;1;KG
5991;56049090;Outros fios de alta tenacidade, de poliesteres, nailon ou de outras poliamidas, ou de raiom viscose, impregnados ou revestidos;1;KG
5992;56050010;Fios metalicos e fios metalizados, mesmo revestidos por enrolamento, constituidos por fios texteis,laminas ou formas semelhantes das posicoes 5404/5405,combinados com metal sob a forma de fios,de laminas ou pos,ou recobertos de metal, com metais preciosos;1;KG
5993;56050020;Fios metalicos e fios metalizados, mesmo revestidos por enrolamento, constituidos por fios texteis,laminas ou formas semelhantes das posicoes 5404/5405,combinados com metal sob a forma de fios,de laminas ou pos,ou recobertos de metal;1;KG
5994;56050090;Outros fios metalicos e fios metalizados, mesmo revestidos por enrolamento, constituidos por fios texteis, laminas ou formas semelhantes das posicoes 54.04 ou 54.05, combinados com metal sob a forma de fios, de laminas ou de pos, ou recobertos de metal;1;KG
5995;56060000;Fios revestidos por enrolamento, laminas e formas semelhantes das posicoes 5404 ou 5405,revestidas por enrolamento, exceto os da posicao 5605 e os fios de crina revestidos por enrolamento,fios de froco (chenille),fios denominados de cadeia (cha�nette);1;KG
5996;56072100;Cordeis para atadeiras ou enfardadeiras, de sisal ou de outras fibras texteis do genero Agave;1;KG
5997;56072900;Outros cordeis, cordas e cabos, de sisal/outras fibras agave;1;KG
5998;56074100;Cordeis para atadeiras ou enfardadeiras, de polietileno ou de polipropileno;1;KG
5999;56074900;Outros cordeis, cordas, etc, de polietileno/polipropileno;1;KG
6000;56075011;Cordeis, cordas e cabos, de fibras de nailon;1;KG
6001;56075019;Cordeis, cordas e cabos, de fibras de outras poliamidas;1;KG
6002;56075090;Cordeis, cordas e cabos, de outras fibras sinteticas;1;KG
6003;56079010;Cordeis, cordas e cabos, de algodao;1;KG
6004;56079020;Cordeis, corda, cabo, de juta, inferior ao numero metrico 0,75 por fio simples;1;KG
6005;56079090;Cordeis, cordas e cabos, de outras materias texteis;1;KG
6006;56081100;Redes confeccionadas para a pesca, de materias texteis sinteticas ou artificiais;1;KG
6007;56081900;Outras redes confeccionadas de materias texteis sinteticas ou artificiais;1;KG
6008;56089000;Redes de malhas com nos, etc, de outras materias texteis;1;KG
6009;56090010;Artigos de fios, laminas ou formas semelhantes das posicoes 54.04 ou 54.05, cordeis, cordas ou cabos, nao especificados nem compreendidos noutras posicoes, de algodao;1;KG
6010;56090090;Artigos de fios, laminas ou formas semelhantes das posicoes 54.04 ou 54.05, cordeis, cordas ou cabos, nao especificados nem compreendidos noutras posicoes, de outras materias;1;KG
6011;57011011;Tapete de la, de pontos nodados ou enrolados, feitos a mao;1;M2
6012;57011012;Tapete de la, de pontos nodados ou enrolados, feitos a maquina;1;M2
6013;57011020;Tapete de pelos finos, de pontos nodados ou enrolados, mesmo confeccionados;1;M2
6014;57019000;Tapete de pontos nodados ou enrolados, mesmo confeccionados, de outras materias texteis;1;M2
6015;57021000;Tapetes denominados Kelim ou Kilim, Schumacks ou Soumak, Karamanie e tapetes semelhantes tecidos a mao;1;M2
6016;57022000;Revestimentos para pisos (pavimentos), de cairo (fibras de coco);1;M2
6017;57023100;Tapete, etc, de la ou de pelos finos, aveludado, nao confeccionado;1;M2
6018;57023200;Tapete, etc, de materias texteis sinteticas ou artificiais, aveludado, nao confeccionado;1;M2
6019;57023900;Tapete, etc, de outras materias texteis, aveludado, nao confeccionado;1;M2
6020;57024100;Tapete, etc, de la ou pelos finos, aveludado, confeccionado;1;M2
6021;57024200;Tapete, etc, de materias texteis sinteticas ou artificiais, aveludado, confeccionado;1;M2
6022;57024900;Tapete, etc, de outras materias texteis, aveludado, confeccionado;1;M2
6023;57025010;Tapetes revestidos para pavimento, nao aveludado, nao confeccionado, de la ou de pelos finos;1;M2
6024;57025020;Tapetes revestidos para pavimento, nao aveludado, nao confeccionado, de materias texteis sinteticas ou artificiais;1;M2
6025;57025090;Tapetes revestidos para pavimento, nao aveludado, nao confeccionado, outras materias;1;M2
6026;57029100;Tapete, etc, de la ou de pelos finos, nao aveludado, confeccionado;1;M2
6027;57029200;Tapete, etc, de materias texteis sinteticas ou artificiais, nao aveludado, confeccionado;1;M2
6028;57029900;Tapete, etc, de outras materias texteis, nao aveludado, confeccionado;1;M2
6029;57031000;Tapete/revestimento para pavimento, de la ou de pelos finos, tufado;1;M2
6030;57032000;Tapete/revestimento para pavimento, de nailon ou de outras poliamidas, tufado;1;M2
6031;57033000;Tapete/revestimento para pavimento, de outras materias texteis sinteticas ou de materias texteis artificiais, tufado;1;M2
6032;57039000;Tapete/revestimento para pavimento, de outras materias texteis;1;M2
6033;57041000;Ladrilhos de feltro, para revestimento de pavimento, de superficie nao superior a 0,3 m2;1;M2
6034;57042000;Ladrilhos de feltro, de area da superficie superior a 0,3 metros quadrados, mas nao superior a 1 metro quadrado;1;M2
6035;57049000;Outros tapetes/revestimentos para pavimento, de feltro;1;M2
6036;57050000;Outros tapetes e revestimentos para pisos (pavimentos), de materias texteis, mesmo confeccionados;1;M2
6037;58011000;Veludos e pelucias tecidos, de la ou pelos finos;1;KG
6038;58012100;Veludos e pelucias obtidos por trama, nao cortados, de algodao;1;KG
6039;58012200;Veludos e pelucias obtidos por trama, cortados, canelados (coteles), de algodao;1;KG
6040;58012300;Outros veludos e pelucias obtidos por trama, de algodao;1;KG
6041;58012600;Tecido de froco (chenille), de algodao;1;KG
6042;58012700;Veludos e pelucias obtidos por urdidura, de algodao;1;KG
6043;58013100;Veludos e pelucias obtidos por trama, nao cortados, de fibras sinteticas ou artificiais;1;KG
6044;58013200;Veludos e pelucias obtidos por trama, cortados, canelados (coteles), de fibras sinteticas ou artificiais;1;KG
6045;58013300;Outros veludos e pelucias obtidos por trama, de fibras sinteticas ou artificiais;1;KG
6046;58013600;Tecido de froco (chenille) de fibras sinteticas ou artificiais;1;KG
6047;58013700;Veludos e pelucias obtidos por urdidura, de fibras sinteticas ou artificiais;1;KG
6048;58019000;Veludos e pelucias, tecido, de outras materias texteis;1;KG
6049;58021100;Tecido atoalhado, de algodao, cru;1;KG
6050;58021900;Outros tecidos atoalhados, de algodao;1;KG
6051;58022000;Tecido atoalhado, de outras materias texteis;1;KG
6052;58023000;Tecidos tufados;1;KG
6053;58030010;Tecidos em ponto de gaze, exceto os artefatos da posicao 58.06, de algodao;1;KG
6054;58030090;Tecidos em ponto de gaze, exceto os artefatos da posicao 58.06, de outras materias texteis;1;KG
6055;58041010;Tules, filo e tecidos de malhas com nos, de algodao;1;KG
6056;58041090;Outras tules, filos e tecidos de malhas com nos;1;KG
6057;58042100;Renda de fibras sinteticas ou artificiais, de fabricacao mecanica;1;KG
6058;58042910;Renda de algodao, de fabricacao mecanica;1;KG
6059;58042990;Renda de outras materias texteis, de fabricacao mecanica;1;KG
6060;58043010;Renda de algodao, de fabricacao manual;1;KG
6061;58043090;Outras rendas de fabricacao manual;1;KG
6062;58050010;Tapecarias de algodao, tecidas a mao ou feitas a agulha;1;KG
6063;58050020;Tapecarias de fibras sinteticas ou artificiais, tecidas a mao, etc;1;KG
6064;58050090;Tapecarias de outras materias texteis, tecidas a mao, etc;1;KG
6065;58061000;Fitas de veludo, de pelucias, de tecidos de froco (chenille) ou de tecidos atoalhados;1;KG
6066;58062000;Outras fitas que contenham, em peso, 5 % ou mais de fios de elastomeros ou de fios de borracha;1;KG
6067;58063100;Fitas de algodao;1;KG
6068;58063200;Fitas de fibras sinteticas ou artificiais;1;KG
6069;58063900;Fitas de outras materias texteis;1;KG
6070;58064000;Fitas sem trama, de fios ou fibras paralelizados e colados (bolducs);1;KG
6071;58071000;Etiquetas, emblemas e artefatos semelhantes de materias texteis, em peca, em fitas ou recortados em forma propria, nao bordados, de tecidos;1;KG
6072;58079000;Etiquetas, emblemas e artefatos semelhantes de materias texteis, em peca, em fitas ou recortados em forma propria, nao bordados, outros materiais;1;KG
6073;58081000;Trancas em pecas;1;KG
6074;58089000;Artigos de passamanaria e artigos ornamentais analogos, em peca, nao bordados, exceto de malha, borlas, pompons e artefatos semelhantes;1;KG
6075;58090000;Tecidos de fios de metal e tecidos de fios metalicos ou de fios texteis metalizados da posicao 56.05, dos tipos utilizados em vestuario, para guarnicao de interiores ou usos semelhantes, nao especificados nem compreendidos noutras posicoes;1;KG
6076;58101000;Bordados quimicos ou aereos e bordados com fundo recortado, em tiras ou em motivos;1;KG
6077;58109100;Bordados de algodao, em peca, em tiras ou em motivos;1;KG
6078;58109200;Bordados de fibras sinteticas ou artificiais, em peca, tiras ou motivos;1;KG
6079;58109900;Bordados de outras materias texteis, em peca/tiras/motivos;1;KG
6080;58110000;Artefatos texteis matelasses em peca, constituidos por uma ou varias camadas de materias texteis associadas a uma materia de enchimento ou estofamento, acolchoados por qualquer processo, exceto os bordados da posicao 58.10;1;KG
6081;59011000;Tecidos revestidos de cola ou de materias amilaceas, dos tipos utilizados na encadernacao, cartonagem ou usos semelhantes;1;KG
6082;59019000;Telas para decalque e telas transparentes para desenho, telas preparadas para pintura, entretelas e tecidos rigidos semelhantes, dos tipos utilizados em chapeus e artefatos de uso semelhante;1;KG
6083;59021010;Telas para pneumaticos com fios de alta tenacidade de nailon ou de outras poliamidas, impregnadas, recobertas ou revestidas com borracha;1;KG
6084;59021090;Outras telas para pneumaticos, de fios de alta tenacidade de nailon ou de outras poliamidas;1;KG
6085;59022000;Telas para pneumaticos fabricadas com fios de alta tenacidade, de poliesteres;1;KG
6086;59029000;Telas para pneumaticos fabricadas com fios de alta tenacidade, de raiom viscose;1;KG
6087;59031000;Tecidos impregnados, revestidos, recobertos ou estratificados, com plastico, exceto os da posicao 59.02, com poli(cloreto de vinila);1;KG
6088;59032000;Tecidos impregnados, revestidos, recobertos ou estratificados, com plastico, exceto os da posicao 59.02, com poliuretano;1;KG
6089;59039000;Tecidos impregnados, revestidos, recobertos ou estratificados, com outros plasticos;1;KG
6090;59041000;Linoleos, mesmo recortados;1;M2
6091;59049000;Revestimentos para pisos (pavimentos) constituidos por um induto ou recobrimento aplicado sobre suporte textil, mesmo recortados;1;M2
6092;59050000;Revestimentos para paredes, de materias texteis;1;M2
6093;59061000;Fitas adesivas de largura nao superior a 20 cm, com borracha;1;KG
6094;59069100;Tecidos de malha, com borracha;1;KG
6095;59069900;Outros tecidos com borracha, exceto os da posicao 59.02;1;KG
6096;59070000;Outros tecidos impregnados, revestidos ou recobertos, telas pintadas para cenarios teatrais, para fundos de estudio ou para usos semelhantes;1;KG
6097;59080000;Mechas de materias texteis, tecidas, entrancadas ou tricotadas, para candeeiros, fogareiros, isqueiros, velas e semelhantes, camisas de incandescencia e tecidos tubulares tricotados para a sua fabricacao, mesmo impregnados;1;KG
6098;59090000;Mangueiras e tubos semelhantes, de materias texteis, mesmo com reforco ou acessorios de outras materias;1;KG
6099;59100000;Correias transportadoras ou de transmissao, de materias texteis, mesmo impregnadas, revestidas ou recobertas, de plastico, ou estratificadas com plastico ou reforcadas com metal ou com outras materias;1;KG
6100;59111000;Tecidos, feltros e tecidos forrados de feltro, combinados com uma ou mais camadas de borracha, couro ou de outras materias, dos tipos utilizados na fabricacao de guarnicoes de cardas, e produtos analogos para outros usos tecnicos, etc...;1;KG
6101;59112010;Gazes e telas para peneirar, mesmo confeccionadas, de materia textil sintetica ou artificial, em peca;1;KG
6102;59112090;Gazes e telas para peneirar, mesmo confeccionadas, de outras materias texteis;1;KG
6103;59113100;Tecidos e feltros, sem fim ou com dispositivos de uniao, dos tipos utilizados nas maquinas para fabricacao de papel ou maquinas semelhantes (para obtencao de pasta de papel ou fibrocimento, por exemplo), de peso inferior a 650 g/m2;1;KG
6104;59113200;Tecidos e feltros, sem fim ou com dispositivos de uniao, dos tipos utilizados nas maquinas para fabricacao de papel ou maquinas semelhantes (para obtencao de pasta de papel ou fibrocimento, por exemplo), de peso igual ou superior a 650 g/m2;1;KG
6105;59114000;Tecidos filtrantes e tecidos espessos, compreendendo os de cabelo, dos tipos usados em prensas de oleo ou outros usos tecnicos analogos;1;KG
6106;59119000;Outros produtos/artefatos, de materias texteis, para uso tecnico;1;KG
6107;60011010;Tecidos de malha denominados de felpa longa ou pelo comprido, de algodao;1;KG
6108;60011020;Tecidos de malha denominados de felpa longa ou pelo comprido, de fibras sinteticas ou artificiais;1;KG
6109;60011090;Tecidos de malha denominados de felpa longa ou pelo comprido, de outras materias texteis;1;KG
6110;60012100;Tecido atoalhado, de malha, de algodao;1;KG
6111;60012200;Tecido atoalhado, de malha, de fibras sinteticas ou artificiais;1;KG
6112;60012900;Tecido atoalhado, de malha, de outras materias texteis;1;KG
6113;60019100;Veludo e pelucia, de malha de algodao;1;KG
6114;60019200;Veludo e pelucia, de malha de fibra sintetica/artificial;1;KG
6115;60019900;Veludo e pelucia, de malha de outras materias texteis;1;KG
6116;60024010;Tecidos de malha de largura nao superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de algodao;1;KG
6117;60024020;Tecidos de malha de largura nao superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras sinteticas ou artificiais;1;KG
6118;60024090;Tecidos de malha de largura nao superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de outras materias texteis;1;KG
6119;60029010;Outros tecidos de malha de algodao, largura <=30cm;1;KG
6120;60029020;Outros tecidos de malha fibra sintetica/artificial, largura <=30 cm;1;KG
6121;60029090;Outros tecidos de malha de largura nao superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros ou de fios de borracha, exceto os da posicao 60.01, de outras materias texteis;1;KG
6122;60031000;Tecidos de malha de largura nao superior a 30 cm, exceto os das posicoes 60.01 e 60.02, de la ou de pelos finos;1;KG
6123;60032000;Tecidos de malha de largura nao superior a 30 cm, exceto os das posicoes 60.01 e 60.02, de algodao;1;KG
6124;60033000;Tecidos de malha de largura nao superior a 30 cm, exceto os das posicoes 60.01 e 60.02, de fibras sinteticas;1;KG
6125;60034000;Tecidos de malha de largura nao superior a 30 cm, exceto os das posicoes 60.01 e 60.02, de fibras artificiais;1;KG
6126;60039000;Outros tecidos de outras materias texteis, largura <= 30 cm;1;KG
6127;60041011;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de algodao, crus ou branqueados;1;KG
6128;60041012;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de algodao, tintos;1;KG
6129;60041013;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de algodao, de fios de diversas cores;1;KG
6130;60041014;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de algodao, estampados;1;KG
6131;60041031;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras sinteticas, crus ou branqueados;1;KG
6132;60041032;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras sinteticas, tintos;1;KG
6133;60041033;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras sinteticas, de fios de diversas cores;1;KG
6134;60041034;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras sinteticas, estampados;1;KG
6135;60041041;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras artificiais, crus ou branqueados;1;KG
6136;60041042;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras artificiais, tintos;1;KG
6137;60041043;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras artificiais, de fios de diversas cores;1;KG
6138;60041044;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de fibras artificiais, estampados;1;KG
6139;60041091;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de outras materias texteis, crus ou branqueados;1;KG
6140;60041092;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de outras materias texteis, tintos;1;KG
6141;60041093;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de outras materias texteis, de fios de diversas cores;1;KG
6142;60041094;Tecidos de malha de largura superior a 30 cm, que contenham, em peso, 5 % ou mais de fios de elastomeros, mas que nao contenham fios de borracha, exceto os da posicao 60.01, de outras materias texteis, estampados;1;KG
6143;60049010;Outros tecidos de malha de largura superior a 30 cm,que contenham, em peso, 5 % ou mais de fios de elastomeros ou de fios de borracha, exceto os da posicao 60.01, de algodao;1;KG
6144;60049030;Outros tecidos de malha de largura superior a 30 cm,que contenham, em peso, 5 % ou mais de fios de elastomeros ou de fios de borracha, exceto os da posicao 60.01, de fibras sinteticas;1;KG
6145;60049040;Outros tecidos de malha de largura superior a 30 cm,que contenham, em peso, 5 % ou mais de fios de elastomeros ou de fios de borracha, exceto os da posicao 60.01, de fibras artificiais;1;KG
6146;60049090;Outros tecidos de malha de largura superior a 30 cm,que contenham, em peso, 5 % ou mais de fios de elastomeros ou de fios de borracha, exceto os da posicao 60.01, de outras materias texteis;1;KG
6147;60052100;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de algodao, crus ou branqueados;1;KG
6148;60052200;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de algodao, tintos;1;KG
6149;60052300;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de algodao, de fios de diversas cores;1;KG
6150;60052400;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de algodao, estampados;1;KG
6151;60053500;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras sinteticas, mencionados na Nota de subposicao 1 do presente Capitulo;1;KG
6152;60053600;Outros tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras sinteticas, crus ou branqueados;1;KG
6153;60053700;Outros tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras sinteticas, tintos;1;KG
6154;60053800;Outros tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fios de diversas cores;1;KG
6155;60053900;Outros tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, estampados;1;KG
6156;60054100;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras artificiais, crus ou branqueados;1;KG
6157;60054200;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras artificiais, tintos;1;KG
6158;60054300;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras artificiais, de fios de diversas cores;1;KG
6159;60054400;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de fibras artificiais, estampados;1;KG
6160;60059010;Tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04, de la ou pelos finos;1;KG
6161;60059090;Outros tecidos de malha-urdidura (incluindo os fabricados em teares para galoes), exceto os das posicoes 60.01 a 60.04.;1;KG
6162;60061000;Outros tecidos de malha, de la ou de pelos finos;1;KG
6163;60062100;Outros tecidos de malha, de algodao, crus ou branqueados;1;KG
6164;60062200;Outros tecidos de malha, de algodao, tingidos;1;KG
6165;60062300;Outros tecidos de malha, de algodao, de fios de diversas cores;1;KG
6166;60062400;Outros tecidos de malha, de algodao, estampados;1;KG
6167;60063110;Outros tecidos de malha, de fibras sinteticas, crus ou branqueados, de nailon ou de outras poliamidas;1;KG
6168;60063120;Outros tecidos de malha, de fibras sinteticas, crus ou branqueados, de poliesteres;1;KG
6169;60063130;Outros tecidos de malha, de fibras sinteticas, crus ou branqueados, acrilicos ou modacrilicos;1;KG
6170;60063190;Outros tecidos de malha, de fibras sinteticas, crus ou branqueados, de outros tipos;1;KG
6171;60063210;Outros tecidos de malha, de fibras sinteticas, tintos, de nailon ou de outras poliamidas;1;KG
6172;60063220;Outros tecidos de malha, de fibras sinteticas, tintos, de poliesteres;1;KG
6173;60063230;Outros tecidos de malha, de fibras sinteticas, tintos, acrilicos ou modacrilicos;1;KG
6174;60063290;Outros tecidos de malha, de fibras sinteticas, tintos, de outros tipos;1;KG
6175;60063310;Outros tecidos de malha, de fibras sinteticas, de fios de diversas cores, de nailon ou de outras poliamidas;1;KG
6176;60063320;Outros tecidos de malha, de fibras sinteticas, de fios de diversas cores, de poliesteres;1;KG
6177;60063330;Outros tecidos de malha, de fibras sinteticas, de fios de diversas cores, acrilicos ou modacrilicos;1;KG
6178;60063390;Outros tecidos de malha, de fibras sinteticas, de fios de diversas cores, de outros tipos;1;KG
6179;60063410;Outros tecidos de malha, de fibras sinteticas, estampados, de nailon ou de outras poliamidas;1;KG
6180;60063420;Outros tecidos de malha, de fibras sinteticas, estampados, de poliesteres;1;KG
6181;60063430;Outros tecidos de malha, de fibras sinteticas, estampados, acrilicos ou modacrilicos;1;KG
6182;60063490;Outros tecidos de malha, de fibras sinteticas, estampados, de outros tipos;1;KG
6183;60064100;Outros tecidos de malha, de fibras artificiais, crus ou branqueados;1;KG
6184;60064200;Outros tecidos de malha, de fibras artificiais, tingidos;1;KG
6185;60064300;Outros tecidos de malha, de fibras artificiais, de fios de diversas cores;1;KG
6186;60064400;Outros tecidos de malha, de fibras artificiais, estampados;1;KG
6187;60069000;Outros tecidos de malha, de outros materias texteis;1;KG
6188;61012000;Sobretudos, japonas, gaboes, capas, anoraques, casacos e semelhantes, de malha, de uso masculino, exceto os artefatos da posicao 61.03, de algodao;1;UN
6189;61013000;Sobretudos, japonas, gaboes, capas, anoraques, casacos e semelhantes, de malha, de uso masculino, exceto os artefatos da posicao 61.03, de fibras sinteticas ou artificiais;1;UN
6190;61019010;Sobretudos, japonas, gaboes, capas, anoraques, casacos e semelhantes, de malha, de uso masculino, exceto os artefatos da posicao 61.03, de la ou pelos finos;1;UN
6191;61019090;Sobretudos, japonas, gaboes, capas, anoraques, casacos e semelhantes, de malha, de uso masculino, exceto os artefatos da posicao 61.03, de outras materias texteis;1;UN
6192;61021000;Mantos, capas, anoraques, casacos e semelhantes, de malha, de uso feminino, exceto os artefatos da posicao 61.04, de la ou de pelos finos;1;UN
6193;61022000;Mantos, capas, anoraques, casacos e semelhantes, de malha, de uso feminino, exceto os artefatos da posicao 61.04, de algodao;1;UN
6194;61023000;Mantos, capas, anoraques, casacos e semelhantes, de malha, de uso feminino, exceto os artefatos da posicao 61.04, de fibras sinteticas ou artificiais;1;UN
6195;61029000;Mantos, capas, anoraques, casacos e semelhantes, de malha, de uso feminino, exceto os artefatos da posicao 61.04, de outras materias texteis;1;UN
6196;61031010;Ternos, de malha, de la ou de pelos finos, uso masculino;1;UN
6197;61031020;Ternos de malha de fibras sinteticas, uso masculino;1;UN
6198;61031090;Ternos de malha de outras materias texteis, uso masculino;1;UN
6199;61032200;Conjuntos de malha, de uso masculino, de algodao;1;UN
6200;61032300;Conjuntos de malha, de uso masculino, de fibras sinteticas;1;UN
6201;61032910;Conjuntos de malha, de uso masculino, de la ou de pelos finos;1;UN
6202;61032990;Conjuntos de malha, de uso masculino, de outras materias texteis;1;UN
6203;61033100;Paletos, de malha, de uso masculino, de la ou de pelos finos;1;UN
6204;61033200;Paletos, de malha, de uso masculino, de algodao;1;UN
6205;61033300;Paletos, de malha, de uso masculino, de fibras sinteticas;1;UN
6206;61033900;Paletos, de malha, de uso masculino, de outras materias texteis;1;UN
6207;61034100;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de uso masculino, de la ou de pelos finos;1;UN
6208;61034200;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de uso masculino, de algodao;1;UN
6209;61034300;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de uso masculino, de fibras sinteticas;1;UN
6210;61034900;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de uso masculino, de outras materias texteis;1;UN
6211;61041300;Tailleurs de malha, de uso feminino, de fibras sinteticas;1;UN
6212;61041910;Tailleurs de malha, de uso feminino, de la ou de pelos finos;1;UN
6213;61041920;Tailleurs de malha, de uso feminino, de algodao;1;UN
6214;61041990;Tailleurs de malha, de uso feminino, de outras materias texteis;1;UN
6215;61042200;Conjuntos de malha, de uso feminino, de algodao;1;UN
6216;61042300;Conjuntos de malha, de uso feminino, de fibras sinteticas;1;UN
6217;61042910;Conjuntos de malha, de uso feminino, de la ou de pelos finos;1;UN
6218;61042990;Conjuntos de malha, de uso feminino, de outras materias texteis;1;UN
6219;61043100;Blazers de malha de uso feminino, de la ou de pelos finos;1;UN
6220;61043200;Blazers de malha de algodao, de uso feminino;1;UN
6221;61043300;Blazers de malha de fibras sinteticas, de uso feminino;1;UN
6222;61043900;Blazers de malha de outras materias texteis, de uso feminino;1;UN
6223;61044100;Vestidos de malha de la ou pelos finos, de uso feminino;1;UN
6224;61044200;Vestidos de malha de algodao, de uso feminino;1;UN
6225;61044300;Vestidos de malha de fibras sinteticas, de uso feminino;1;UN
6226;61044400;Vestidos de malha de fibras artificiais, de uso feminino;1;UN
6227;61044900;Vestidos de malha de outras materias texteis, de uso feminino;1;UN
6228;61045100;Saias e saias-calcas, de malha, de la ou de pelos finos;1;UN
6229;61045200;Saias e saias-calcas, de malha, de algodao;1;UN
6230;61045300;Saias e saias-calcas, de malha, de fibras sinteticas;1;UN
6231;61045900;Saias e saias-calcas, de malha, de outras materias texteis;1;UN
6232;61046100;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de la ou pelos finos, uso feminino;1;UN
6233;61046200;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de algodao, de uso feminino;1;UN
6234;61046300;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de fibras sinteticas, uso feminino;1;UN
6235;61046900;Calcas, jardineiras, bermudas e shorts (calcoes), de malha, de outras materias texteis, uso feminino;1;UN
6236;61051000;Camisas de malha, de uso masculino, de algodao;1;UN
6237;61052000;Camisas de malha, de uso masculino, de fibras sinteticas ou artificiais;1;UN
6238;61059000;Camisas de malha, de uso masculino, de outras materias texteis;1;UN
6239;61061000;Camisas, blusas, blusas chemisiers, de malha, de uso feminino, de algodao;1;UN
6240;61062000;Camisas, blusas, blusas chemisiers, de malha, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6241;61069000;Camisas, blusas, blusas chemisiers, de malha, de uso feminino, de outras materias texteis;1;UN
6242;61071100;Cuecas e ceroulas, de malha, de uso masculino, de algodao;1;UN
6243;61071200;Cuecas e ceroulas, de malha, de uso masculino, de fibras sinteticas ou artificiais;1;UN
6244;61071900;Cuecas e ceroulas, de malha, de uso masculino, de outras materias texteis;1;UN
6245;61072100;Camisoloes e pijamas, de malha, de uso masculino, de algodao;1;UN
6246;61072200;Camisoloes e pijamas, de malha, de uso masculino, de fibras sinteticas ou artificiais;1;UN
6247;61072900;Camisoloes e pijamas, de malha, de uso masculino, de outras materias texteis;1;UN
6248;61079100;Roupoes de banho, robes e semelhantes, de malha, de uso masculino, de algodao;1;UN
6249;61079910;Roupoes de banho, robes e semelhantes, de malha, de uso masculino, de fibras sinteticas ou artificiais;1;UN
6250;61079990;Outros roupoes de banho, robes e semelhantes, de malha, de uso masculino;1;UN
6251;61081100;Combinacoes e anaguas, de malha, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6252;61081900;Combinacoes e anaguas, de malha de outras materias texteis;1;UN
6253;61082100;Calcinhas, de malha, de uso feminino, de algodao;1;UN
6254;61082200;Calcinhas, de malha, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6255;61082900;Calcinhas, de malha, de uso feminino, de outras materias texteis;1;UN
6256;61083100;Camisolas e pijamas, de malha, de uso feminino, de algodao;1;UN
6257;61083200;Camisolas e pijamas, de malha, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6258;61083900;Camisolas e pijamas, de malha, de uso feminino, de outras materias texteis;1;UN
6259;61089100;Roupoes de banho, penhoares e semelhantes, de malha, de uso feminino, de algodao;1;UN
6260;61089200;Roupoes de banho, penhoares e semelhantes, de malha, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6261;61089900;Roupoes de banho, penhoares e semelhantes, de malha, de uso feminino, de outras materias texteis;1;UN
6262;61091000;Camisetas, incluindo as interiores, de malha, de algodao;1;UN
6263;61099000;Camisetas, incluindo as interiores, de malha, de outras materias texteis;1;UN
6264;61101100;Sueteres, puloveres, cardigas, coletes e artigos semelhantes, de malha, de la;1;UN
6265;61101200;Sueteres, puloveres, cardigas, coletes e artigos semelhantes, de malha, de cabra de Caxemira;1;UN
6266;61101900;Sueteres, puloveres, cardigas, coletes e artigos semelhantes, de malha, de outros pelos finos;1;UN
6267;61102000;Sueteres, puloveres, cardigas, coletes e artigos semelhantes, de malha, de algodao;1;UN
6268;61103000;Sueteres, puloveres, cardigas, coletes e artigos semelhantes, de malha, de fibras sinteticas ou artificiais;1;UN
6269;61109000;Sueteres, puloveres, cardigas, coletes e artigos semelhantes, de malha, de outras materias texteis;1;UN
6270;61112000;Vestuario para bebes e acessorios, de malha, de algodao;1;UN
6271;61113000;Vestuario para bebes e acessorios, de malha de fibras sinteticas;1;UN
6272;61119010;Vestuario para bebes e acessorios, de malha, de la ou pelos finos;1;UN
6273;61119090;Vestuario para bebes e acessorios, de malha, de outras materias texteis;1;UN
6274;61121100;Abrigos para esporte, de malha, de algodao;1;UN
6275;61121200;Abrigos para esporte, de malha, de fibras sinteticas;1;UN
6276;61121900;Abrigos para esporte, de malha, de outras materias texteis;1;UN
6277;61122000;Macacoes e conjuntos de esqui, de malha;1;UN
6278;61123100;Maios, shorts (calcoes) e sungas de banho, de malha, de uso masculino, de fibras sinteticas;1;UN
6279;61123900;Maios, shorts (calcoes) e sungas de banho, de malha, de uso masculino, de outras materias texteis;1;UN
6280;61124100;Maios e biquinis de banho, de malha, de uso feminino, de fibras sinteticas;1;UN
6281;61124900;Maios e biquinis de banho, de malha, de uso feminino, de outras materias texteis;1;UN
6282;61130000;Vestuario confeccionado com tecidos de malha das posicoes 59.03, 59.06 ou 59.07;1;UN
6283;61142000;Outros vestuarios de malha de algodao;1;UN
6284;61143000;Outros vestuarios de malha de fibra sintetica/artificial;1;UN
6285;61149010;Vestuario de malha, de la ou de pelos finos;1;UN
6286;61149090;Vestuario de malha, de outras materias texteis;1;UN
6287;61151011;Meias-calcas, de fibras sinteticas, de titulo inferior a 67 decitex, por fio simples;1;UN
6288;61151012;Meias-calcas, de fibras sinteticas, de titulo igual ou superior a 67 decitex, por fio simples;1;UN
6289;61151013;Meias-calcas, de malha, de la ou de pelos finos;1;UN
6290;61151014;Meias-calcas, de malha, de algodao;1;UN
6291;61151019;Meias-calcas, de malha, de outras materias texteis;1;UN
6292;61151021;Meias acima do joelho e meias ate o joelho, de uso feminino, de titulo inferior a 67 decitex por fio simples, de fibras sinteticas ou artificiais;1;PARES
6293;61151022;Meias acima do joelho e meias ate o joelho, de uso feminino, de titulo inferior a 67 decitex por fio simples, de algodao;1;PARES
6294;61151029;Meias acima do joelho e meias ate o joelho, de uso feminino, de titulo inferior a 67 decitex por fio simples, de outras materias texteis;1;PARES
6295;61151091;Outras meias-calcas e semelhantes, de la ou de pelos finos;1;PARES
6296;61151092;Outras meias e semelhanrtes, de malha, de algodao;1;PARES
6297;61151093;Outras meias e semelhantes, de malha, de fibras sinteticas;1;PARES
6298;61151099;Outras meias-calcas, de malha, de outras materias texteis;1;PARES
6299;61152100;Outras meias-calcas de fibras sinteticas, de titulo inferior a 67 decitex, por fio simples;1;UN
6300;61152200;Outras meias-calcas de fibras sinteticas, de titulo igual ou superior a 67 decitex, por fio simples;1;UN
6301;61152910;Outras meias-calcas de malha, de la ou de pelos finos;1;UN
6302;61152920;Outras meias-calcas de malha, de algodao;1;UN
6303;61152990;Outras meias-calcas de outras materias texteis;1;UN
6304;61153010;Outras meias acima do joelho e meias ate o joelho, de uso feminino, de titulo inferior a 67 decitex por fio simples, de fibras sinteticas ou artificiais;1;PARES
6305;61153020;Outras meias acima do joelho e meias ate o joelho, de uso feminino, de titulo inferior a 67 decitex por fio simples, de algodao;1;PARES
6306;61153090;Outras meias acima do joelho e meias ate o joelho, de uso feminino, de titulo inferior a 67 decitex por fio simples, de outras materias texteis;1;PARES
6307;61159400;Outras meias-calcas e semelhantes, de la ou de pelos finos;1;PARES
6308;61159500;Outras meias e semelhantes, de malha de algodao;1;PARES
6309;61159600;Outras meias-calcas e semelhantes, de malha. de fibras sinteticas;1;PARES
6310;61159900;Outras meias de malha de outras materias texteis;1;PARES
6311;61161000;Luvas, mitenes e semelhantes, de malha, impregnadas, revestidas ou recobertas, de plasticos ou de borracha;1;PARES
6312;61169100;Luvas, mitenes e semelhantes, de malha, de la ou de pelos finos;1;PARES
6313;61169200;Luvas, mitenes e semelhantes, de malha, de algodao;1;PARES
6314;61169300;Luvas, mitenes e semelhantes, de malha, de fibras sinteticas;1;PARES
6315;61169900;Luvas, mitenes e semelhantes, de malha, de outras materias texteis;1;PARES
6316;61171000;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e semelhantes, de malha;1;UN
6317;61178010;Gravatas, gravatas-borboletas e plastrons, de malha;1;KG
6318;61178090;Outros acessorios de vestidos confeccionados, de malha;1;KG
6319;61179000;Partes de vestuarios ou seus acessorios, de malha;1;KG
6320;62011100;Sobretudos, impermeaveis, japonas, gaboes, capas e semelhantes, de uso masculino, de la ou de pelos finos;1;UN
6321;62011200;Sobretudos, impermeaveis, japonas, gaboes, capas e semelhantes, de uso masculino, de algodao;1;UN
6322;62011300;Sobretudos, impermeaveis, japonas, gaboes, capas e semelhantes, de uso masculino, de fibras sinteticas ou artificiais;1;UN
6323;62011900;Sobretudos, impermeaveis, japonas, gaboes, capas e semelhantes, de uso masculino, de outras materias texteis;1;UN
6324;62019100;Outros sobretudos, etc, de la/pelos finos, de uso masculino;1;UN
6325;62019200;Outros sobretudos, etc, de algodao, de uso masculino;1;UN
6326;62019300;Outros sobretudos, etc, de fibras sinteticas ou artificiais, de uso masculino;1;UN
6327;62019900;Outros sobretudos, etc, de outras materias texteis, de uso masculino;1;UN
6328;62021100;Mantos, impermeaveis, capas e semelhantes, de uso feminino, de la ou de pelos finos;1;UN
6329;62021200;Mantos, impermeaveis, capas e semelhantes, de uso feminino, de algodao;1;UN
6330;62021300;Mantos, impermeaveis, capas e semelhantes, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6331;62021900;Mantos, impermeaveis, capas e semelhantes, de uso feminino, de outras materias texteis;1;UN
6332;62029100;Outros mantos, etc, de la ou pelos finos, de uso feminino;1;UN
6333;62029200;Outros mantos, etc, de algodao, de uso feminino;1;UN
6334;62029300;Outros mantos, etc, de fibras sinteticas ou artificiais, de uso feminino;1;UN
6335;62029900;Outros mantos, etc, de outras materias texteis, uso feminino;1;UN
6336;62031100;Ternos, de uso masculino, de la ou de pelos finos;1;UN
6337;62031200;Ternos, de uso masculino, de fibras sinteticas;1;UN
6338;62031900;Ternos, de uso masculino, de outras materias texteis;1;UN
6339;62032200;Conjuntos, de uso masculino, de algodao;1;UN
6340;62032300;Conjuntos, de uso masculino, de fibras sinteticas;1;UN
6341;62032910;Conjuntos, de uso masculino, de la ou de pelos finos;1;UN
6342;62032990;Conjuntos de outras materias texteis, de uso masculino;1;UN
6343;62033100;Paletos, de uso masculino, de la ou de pelos finos;1;UN
6344;62033200;Paletos, de uso masculino, de algodao;1;UN
6345;62033300;Paletos, de uso masculino, de fibras sinteticas;1;UN
6346;62033900;Paletos, de uso masculino, de outras materias texteis;1;UN
6347;62034100;Calcas, jardineiras, bermudas e shorts (calcoes), de uso masculino, de la ou de pelos finos;1;UN
6348;62034200;Calcas, jardineiras, bermudas e shorts (calcoes), de uso masculino, de algodao;1;UN
6349;62034300;Calcas, jardineiras, bermudas e shorts (calcoes),de fibras sinteticas;1;UN
6350;62034900;Calcas, jardineiras, bermudas e shorts (calcoes), de uso masculino, de outras materias texteis;1;UN
6351;62041100;Tailleurs, de uso feminino, de la ou de pelos finos;1;UN
6352;62041200;Tailleurs, de uso feminino, de algodao;1;UN
6353;62041300;Tailleurs, de uso feminino, de fibras sinteticas;1;UN
6354;62041900;Tailleurs, de uso feminino, de outras materias texteis;1;UN
6355;62042100;Conjuntos, de uso feminino, de la ou de pelos finos;1;UN
6356;62042200;Conjuntos, de uso feminino, de algodao;1;UN
6357;62042300;Conjuntos, de uso feminino, de fibras sinteticas;1;UN
6358;62042900;Conjuntos, de uso feminino, de outras materias texteis;1;UN
6359;62043100;Blazers, de uso feminino, de la ou de pelos finos;1;UN
6360;62043200;Blazers, de uso feminino, de algodao;1;UN
6361;62043300;Blazers, de uso feminino, de fibras sinteticas;1;UN
6362;62043900;Blazers, de uso feminino, de outras materias texteis;1;UN
6363;62044100;Vestidos, de uso feminino, de la ou de pelos finos;1;UN
6364;62044200;Vestidos, de uso feminino, de algodao;1;UN
6365;62044300;Vestidos, de uso feminino, de fibras sinteticas;1;UN
6366;62044400;Vestidos, de uso feminino, de fibras artificiais;1;UN
6367;62044900;Vestidos, de uso feminino, de outras materias texteis;1;UN
6368;62045100;Saias e saias-calcas, de uso feminino, de la ou de pelos finos;1;UN
6369;62045200;Saias e saias-calcas, de uso feminino, de algodao;1;UN
6370;62045300;Saias e saias-calcas, de uso feminino, de fibras sinteticas;1;UN
6371;62045900;Saias e saias-calcas, de uso feminino, de outras materias texteis;1;UN
6372;62046100;Calcas, jardineiras, bermudas e shorts (calcoes), de uso feminino, de la ou de pelos finos;1;UN
6373;62046200;Calcas, jardineiras, bermudas e shorts (calcoes), de uso feminino, de algodao;1;UN
6374;62046300;Calcas, jardineiras, bermudas e shorts (calcoes), de uso feminino, de fibras sinteticas;1;UN
6375;62046900;Calcas, jardineiras, bermudas e shorts (calcoes), de uso feminino, de outras materias texteis;1;UN
6376;62052000;Camisas de uso masculino, de algodao;1;UN
6377;62053000;Camisas de uso masculino, de fibras sinteticas ou artificiais;1;UN
6378;62059010;Camisas de uso masculino, de la ou de pelos finos;1;UN
6379;62059090;Camisas de uso masculino, de outras materias texteis;1;UN
6380;62061000;Camisas, blusas, blusas chemisiers, de uso feminino, de seda ou de desperdicios de seda;1;UN
6381;62062000;Camisas, blusas, blusas chemisiers, de uso feminino, de la ou de pelos finos;1;UN
6382;62063000;Camisas, blusas, blusas chemisiers, de uso feminino, de algodao;1;UN
6383;62064000;Camisas, blusas, blusas chemisiers, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6384;62069000;Camisas, blusas, blusas chemisiers, de uso feminino, de outras materias texteis;1;UN
6385;62071100;Cuecas e ceroulas, de algodao;1;UN
6386;62071900;Cuecas e ceroulas, de outras materias texteis;1;UN
6387;62072100;Camisoloes e pijamas, de uso masculino, de algodao;1;UN
6388;62072200;Camisoloes e pijamas, de uso masculino, de fibras sinteticas ou artificiais;1;UN
6389;62072900;Camisoloes e pijamas, de uso masculino, de outras materias texteis;1;UN
6390;62079100;Camisetas interiores, etc, de algodao, de uso masculino;1;UN
6391;62079910;Outros (camisetas, rob., semelhantes), de fibras sinteticas/articiais, uso masculino;1;UN
6392;62079990;Outros (camisetas, robes, semelhantes), de outras materias texteis, uso masculino;1;UN
6393;62081100;Combinacoes e anaguas, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6394;62081900;Combinacoes e anaguas, de uso feminino, de outras materias texteis;1;UN
6395;62082100;Camisolas e pijamas, de uso feminino, de algodao;1;UN
6396;62082200;Camisolas e pijamas, de uso feminino, de fibras sinteticas ou artificiais;1;UN
6397;62082900;Camisolas e pijamas, de uso feminino, de outras materias texteis;1;UN
6398;62089100;Corpetes, calcinhas, penhoares, etc., de algodao;1;UN
6399;62089200;Corpetes, calcinhas, penhoares, etc, de fibras sinteticas/artificiais;1;UN
6400;62089900;Corpetes, calcinhas, penhoares, etc, de outras materias texteis;1;UN
6401;62092000;Vestuario e seus acessorios, para bebes, de algodao;1;UN
6402;62093000;Vestuario e seus acessorios, para bebes, de fibras sinteticas;1;UN
6403;62099010;Vestuario e seus acessorios, para bebes, de la ou de pelos finos;1;UN
6404;62099090;Vestuario e seus acessorios, para bebes, de outras materias texteis;1;UN
6405;62101000;Vestuario confeccionado com feltros ou falsos tecidos;1;UN
6406;62102000;Sobretudos, impermeaveis, etc, de materia textil com plastico/borracha;1;UN
6407;62103000;Mantos, impermeaveis, etc, de materia textil com plastico/borracha;1;UN
6408;62104000;Outros vestuarios confeccionados com plastico/borracha, masculino;1;UN
6409;62105000;Outros vestuarios confeccionados com plastico/borracha, feminino;1;UN
6410;62111100;Shorts e sungas, de banho, exceto de malha;1;UN
6411;62111200;Maios e biquinis, de banho, exceto de malha;1;UN
6412;62112000;Macacoes e conjuntos, de esqui, exceto de malha;1;UN
6413;62113200;Outro vestuario de uso masculino, de algodao;1;UN
6414;62113300;Outro vestuario de uso masculino, de fibras sinteticas ou artificiais;1;UN
6415;62113910;Outro vestuario de uso masculino, de la ou de pelos finos;1;UN
6416;62113990;Outro vestuario de uso masculino, de outras materias texteis;1;UN
6417;62114200;Outro vestuario de uso feminino, de algodao;1;UN
6418;62114300;Outro vestuario de uso feminino, de fibras sinteticas ou artificiais;1;UN
6419;62114900;Outro vestuario de uso feminino, de outras materias texteis;1;UN
6420;62121000;Sutias e busties;1;UN
6421;62122000;Cintas e cintas-calcas;1;UN
6422;62123000;Modeladores de torso inteiro;1;UN
6423;62129000;Espartilhos, suspensorios, ligas, artefatos semelhantes e suas partes;1;UN
6424;62132000;Lencos de assoar e de bolso, de algodao;1;UN
6425;62139010;Lencos de assoar e de bolso, de seda ou de desperdicios de seda;1;UN
6426;62139090;Lencos de assoar e de bolso, de outras materias texteis;1;UN
6427;62141000;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e artefatos semelhantes, de seda ou de desperdicios de seda;1;UN
6428;62142000;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e artefatos semelhantes, de la ou de pelos finos;1;UN
6429;62143000;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e artefatos semelhantes, de fibras sinteticas;1;UN
6430;62144000;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e artefatos semelhantes, de fibras artificiais;1;UN
6431;62149010;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e artefatos semelhantes, de algodao;1;UN
6432;62149090;Xales, echarpes, lencos de pescoco, cachenes, cachecois, mantilhas, veus e artefatos semelhantes, de outras materias texteis;1;UN
6433;62151000;Gravatas, gravatas-borboletas e plastrons, de seda ou de desperdicios de seda;1;UN
6434;62152000;Gravatas, gravatas-borboletas e plastrons, de fibras sinteticas ou artificiais;1;UN
6435;62159000;Gravatas, gravatas-borboletas e plastrons, de outras materias texteis;1;UN
6436;62160000;Luvas, mitenes e semelhantes;1;PARES
6437;62171000;Outros acessorios confeccionados de vestuario;1;KG
6438;62179000;Outras partes de vestuario ou dos seus acessorios;1;KG
6439;63011000;Cobertores e mantas, eletricos;1;UN
6440;63012000;Cobertores e mantas (exceto os eletricos), de la ou de pelos finos;1;KG
6441;63013000;Cobertores e mantas (exceto os eletricos), de algodao;1;KG
6442;63014000;Cobertores e mantas (exceto os eletricos), de fibras sinteticas;1;KG
6443;63019000;Outros cobertores e mantas;1;KG
6444;63021000;Roupas de cama, de malha;1;KG
6445;63022100;Roupas de cama, de algodao, estampadas;1;KG
6446;63022200;Roupas de cama, de fibras sinteticas ou artificiais, estampadas;1;KG
6447;63022900;Roupas de cama, de outras materias texteis, estampadas;1;KG
6448;63023100;Outras roupas de cama, de algodao;1;KG
6449;63023200;Outras roupas de cama, de fibras sinteticas ou artificiais;1;KG
6450;63023900;Outras roupas de cama, de outras materias texteis;1;KG
6451;63024000;Roupas de mesa, de malha;1;KG
6452;63025100;Roupas de mesa, de algodao, exceto de malha;1;KG
6453;63025300;Roupas de mesa, de fibras sinteticas ou artificiais, exceto de malha;1;KG
6454;63025910;Roupas de mesa de linho, exceto de malha;1;KG
6455;63025990;Outras roupas de mesa de outras materias texteis;1;KG
6456;63026000;Roupas de toucador ou de cozinha, de tecidos atoalhados de algodao;1;KG
6457;63029100;Outras roupas de toucador ou de cozinha, de algodao;1;KG
6458;63029300;Roupas de toucador/cozinha, de fibras sinteticas ou artificiais;1;KG
6459;63029910;Outras roupas/cama/cozinha/toucador/mesa, de linho;1;KG
6460;63029990;Outras roupas/cama/cozinha/toucador/mesa, de outras materias texteis;1;KG
6461;63031200;Cortinados, cortinas, reposteiros e estores, sanefas, de malha, de fibras sinteticas;1;KG
6462;63031910;Cortinados, cortinas, reposteiros e estores, sanefas, de malha, de algodao;1;KG
6463;63031990;Cortinados, cortinado estampado, sanefas, semelhantes, de malha de outra materia textil;1;KG
6464;63039100;Cortinados, cortinas, reposteiros e estores, sanefas, de algodao, exceto de malha;1;KG
6465;63039200;Cortinados, cortinas, reposteiros e estores, sanefas, de fibras sinteticas, exceto de malha;1;KG
6466;63039900;Cortinados, cortinas, reposteiros e estores, sanefas, de outras materias texteis, exceto de malha;1;KG
6467;63041100;Colchas de malha;1;KG
6468;63041910;Colchas de algodao, exceto de malha;1;KG
6469;63041990;Colchas de outras materias texteis;1;KG
6470;63042000;Mosquiteiros para camas mencionados na Nota de subposicao 1 do presente Capitulo;1;KG
6471;63049100;Outros artefatos para guarnicao de interiores, de malha;1;KG
6472;63049200;Outros artefatos para guarnicao de interiores, de algodao, exceto de malha;1;KG
6473;63049300;Outros artefatos para guarnicao de interiores, de fibra sintetica, exceto de malha;1;KG
6474;63049900;Outros artefatos para guarnicao de interiores, de outras materias texteis, exceto malha;1;KG
6475;63051000;Sacos de quaisquer dimensoes, para embalagem, de juta ou de outras fibras texteis liberianas da posicao 53.03;1;KG
6476;63052000;Sacos de quaisquer dimensoes, para embalagem, de algodao;1;KG
6477;63053200;Recipientes flexiveis para produtos a granel, de materias texteis sinteticas ou artificiais;1;KG
6478;63053310;Sacos de quaisquer dimensoes, para embalagem, de malha, de polietileno ou de polipropileno;1;KG
6479;63053390;Outros sacos para embalagem, de laminas de polietileno, etc.;1;KG
6480;63053900;Sacos para embalagem, de outras materias texteis sinteticas ou artificiais;1;KG
6481;63059000;Outros sacos para embalagem;1;KG
6482;63061200;Encerados e toldos, de fibras sinteticas;1;KG
6483;63061910;Encerados e toldos, de algodao;1;KG
6484;63061990;Encerados e toldos, de outras materias texteis;1;KG
6485;63062200;Tendas, de fibras sinteticas;1;KG
6486;63062910;Tendas, de algodao;1;KG
6487;63062990;Tendas, de outras materias texteis;1;KG
6488;63063010;Velas para embarcacoes, para pranchas a vela ou para carros a vela, de fibras sinteticas;1;KG
6489;63063090;Velas para embarcacoes, para pranchas a vela ou para carros a vela, de outras materias texteis;1;KG
6490;63064010;Colchoes pneumaticos, de algodao;1;KG
6491;63064090;Colchoes pneumaticos, de outras materias texteis;1;KG
6492;63069000;Outros artigos para acampamento, outros encerados e toldos;1;KG
6493;63071000;Rodilhas, esfregoes, panos de prato ou de cozinha, flanelas e artefatos de limpeza semelhantes;1;KG
6494;63072000;Cintos e coletes salva-vidas;1;KG
6495;63079010;Outros artefatos confeccionados, de falso tecido;1;KG
6496;63079020;Artefato tubular com tratamento ignifugo, proprio para saida de emergencia de pessoas, mesmo com seus elementos de montagem;1;KG
6497;63079090;Outros artefatos texteis confeccionados;1;KG
6498;63080000;Sortidos constituidos por cortes de tecido e fios, mesmo com acessorios, para confeccao de tapetes, tapecarias, toalhas de mesa ou guardanapos, bordados, ou artefatos texteis semelhantes, em embalagens para venda a retalho;1;KG
6499;63090010;Vestuario, seus acessorios e suas partes, usados;1;KG
6500;63090090;Outros artefatos de materias texteis, usados;1;KG
6501;63101000;Trapos, cordeis, cordas e cabos de materias texteis, em forma de desperdicios ou de artefatos inutilizados,  escolhidos;1;KG
6502;63109000;Outros trapos, cordeis, etc, de materias texteis, em desperdicios;1;KG
6503;64011000;Calcados impermeaveis e borracha/plastico, com biqueira protetora de metal;1;PARES
6504;64019200;Calcados impermeaveis de borracha/plastico cobrindo tornozelo;1;PARES
6505;64019910;Outros calcados cobrindo o joelho, sola exterior de borracha/plastico;1;PARES
6506;64019990;Outros calcados impermeaveis de borracha/plastico s/const.;1;PARES
6507;64021200;Calcados para esqui e para surfe de neve, de borracha/plastico;1;PARES
6508;64021900;Calcados para outros esportes, de borracha ou plastico;1;PARES
6509;64022000;Calcados de borracha ou plasticos, com parte superior em tiras ou correias, fixados a sola por pregos, tachas, pinos e semelhantes;1;PARES
6510;64029110;Outros calcados cobrindo o tornozelo, com biqueira protetora de metal;1;PARES
6511;64029190;Outros calcados cobrindo o tornozelo, parte superior de borracha, plastico;1;PARES
6512;64029910;Outros calcados cobrindo o tornozelo, com biqueira protetora de metal;1;PARES
6513;64029990;Outros calcados cobrindo o tornozelo, parte superior de borracha, plastico;1;PARES
6514;64031200;Calcados para esqui e para surfe de neve, de couro natural;1;PARES
6515;64031900;Calcados para outros esportes, de couro natural;1;PARES
6516;64032000;Calcados de couro natural, com parte superior em tiras, etc.;1;PARES
6517;64034000;Outros calcados de couro natural, com biqueira protetora de metal;1;PARES
6518;64035110;Calcados com sola de madeira, sem palmilha e biqueira protetora de metal;1;PARES
6519;64035190;Outros calcados sola exterior de couro natural, cobrindo o tornozelo;1;PARES
6520;64035910;Calcados com sola de madeira, sem palmilha e biqueira protetora de metal;1;PARES
6521;64035990;Outros calcados sola exterior de couro natural, cobrindo o tornozelo;1;PARES
6522;64039110;Calcados com sola de madeira, sem palmilha e biqueira protetora de metal;1;PARES
6523;64039190;Outros calcados sola exterior de couro natural, cobrindo o tornozelo;1;PARES
6524;64039910;Calcados com sola de madeira, sem palmilha e biqueira protetora de metal;1;PARES
6525;64039990;Outros calcados sola exterior borracha/plastico, de couro/natural;1;PARES
6526;64041100;Calcados para esportes, etc, de materias texteis, sola borracha/plastico;1;PARES
6527;64041900;Outros calcados de materia textil, sola de borracha/plastico;1;PARES
6528;64042000;Calcados de materia textil, com sola exterior de couro;1;PARES
6529;64051010;Calcados de couro reconstituido, sola exterior de borracha/plastico;1;PARES
6530;64051020;Calcados de couro reconstituido, sola exterior de couro;1;PARES
6531;64051090;Outros calcados de couro natural ou reconstituido;1;PARES
6532;64052000;Outros calcados de materias texteis;1;PARES
6533;64059000;Outros calcados;1;PARES
6534;64061000;Partes superiores de calcados e seus componentes;1;PARES
6535;64062000;Solas exteriores e saltos, de borracha ou plastico;1;KG
6536;64069010;Solas exteriores e saltos, de couro natural ou reconstituido;1;KG
6537;64069020;Palmilhas;1;KG
6538;64069090;Outras partes de calcados, etc;1;KG
6539;65010000;Esbocos nao enformados nem na copa nem na aba, discos e cilindros, mesmo cortados no sentido da altura, de feltro, para chapeus;1;KG
6540;65020010;Esbocos de chapeus, entrancados ou obtidos por reuniao de tiras de qualquer materia, sem copa nem aba enformadas e sem guarnicoes, de palha fina (manila, panama e semelhantes);1;KG
6541;65020090;Esbocos de chapeus, entrancados ou obtidos por reuniao de tiras de qualquer materia, sem copa nem aba enformadas e sem guarnicoes, de outras materias;1;KG
6542;65040010;Chapeus e outros artefatos de uso semelhante, entrancados ou obtidos por reuniao de tiras, de qualquer materia, mesmo guarnecidos, de palha fina (manila, panama e semelhantes);1;KG
6543;65040090;Chapeus e outros artefatos de uso semelhante, entrancados ou obtidos por reuniao de tiras, de qualquer materia, mesmo guarnecidos, de outras materias;1;KG
6544;65050011;Bones de algodao;1;KG
6545;65050012;Bones de fibras sinteticas ou artificiais;1;KG
6546;65050019;Bones de outras materias texteis;1;KG
6547;65050021;Gorros de algodao;1;KG
6548;65050022;Gorros de fibras sinteticas ou artificiais;1;KG
6549;65050029;Gorros de outras materias texteis;1;KG
6550;65050031;Chapeus de algodao;1;KG
6551;65050032;Chapeus de fibras sinteticas ou artificiais;1;KG
6552;65050039;Chapeus de outras materias texteis;1;KG
6553;65050090;Artigos de uso semelhante a chapeu, coifas e rede para cabelo;1;KG
6554;65061000;Capacetes e artefatos de uso semelhante, de protecao;1;UN
6555;65069100;Outros chapeus e artefatos de uso semelhante, mesmo guarnecidos, de borracha ou de plastico;1;KG
6556;65069900;Outros chapeus e artefatos de uso semelhante, mesmo guarnecidos, de outras materias;1;KG
6557;65070000;Carneiras, forros, capas, armacoes, palas e barbicachos, para chapeus e artefatos de uso semelhante;1;KG
6558;66011000;Guarda-sois de jardim e artefatos semelhantes;1;UN
6559;66019110;Guarda-chuvas de haste ou cabo telescopico, cobertos de tecido de seda ou de materias texteis sinteticas ou artificiais;1;UN
6560;66019190;Outros guarda-chuvas, sombrinhas, de haste ou cabo telescopico;1;UN
6561;66019900;Outros guarda-chuvas, sombrinhas e guarda-sois;1;UN
6562;66020000;Bengalas, bengalas-assentos, chicotes, pingalins e artefatos semelhantes;1;UN
6563;66032000;Armacoes montadas, mesmo com hastes ou cabos, para guarda-chuvas, sombrinhas ou guarda-sois;1;KG
6564;66039000;Outras partes, guarnicoes e acessorios para guarda-chuvas, etc.;1;KG
6565;67010000;Peles e outras partes de aves, com as suas penas ou penugem, penas, partes de penas, penugem e artefatos destas materias, exceto os produtos da posicao 05.05, bem como os calamos e outros canos de penas, trabalhados;1;KG
6566;67021000;Flores, folhagem e frutos, artificiais, e suas partes, artefatos confeccionados com flores, folhagem e frutos, artificiais, de plastico;1;KG
6567;67029000;Flores, folhagem e frutos, artificiais, e suas partes, artefatos confeccionados com flores, folhagem e frutos, artificiais, de outras materias;1;KG
6568;67030000;Cabelos dispostos no mesmo sentido, adelgacados, branqueados ou preparados de outro modo, la, pelos e outras materias texteis, preparados para a fabricacao de perucas ou de artefatos semelhantes;1;KG
6569;67041100;Perucas completas, de materias texteis sinteticas;1;KG
6570;67041900;Barbas, sobrancelhas, etc, de materias texteis sinteticas;1;KG
6571;67042000;Perucas, barbas, sobrancelhas, etc, de cabelo;1;KG
6572;67049000;Perucas, barbas, sobrancelhas, etc, de outras materias texteis;1;KG
6573;68010000;Pedras para calcetar, meios-fios e placas (lajes) para pavimentacao, de pedra natural (exceto a ardosia);1;KG
6574;68021000;Ladrilhos, cubos, pastilhas e artigos semelhantes, mesmo de forma diferente da quadrada ou retangular, cuja maior superficie possa ser inscrita num quadrado de lado inferior a 7 cm, granulos, fragmentos e pos, corados artificialmente;1;KG
6575;68022100;Marmore, travertino e alabastro, simplesmente talhados ou serrados, de superficie plana ou lisa;1;M2
6576;68022300;Granito, simplesmente talhados ou serrados, de superficie plana ou lisa;1;M2
6577;68022900;Outras pedras de cantaria, simplesmente talhadas ou serradas, de superficie plana ou lisa;1;M2
6578;68029100;Marmore, travertino e alabastro, trabalhado de outro modo, e obras;1;KG
6579;68029200;Outras pedras calcarias, trabalhadas de outro modo e obras;1;KG
6580;68029310;Esferas para moinho, de granito;1;KG
6581;68029390;Outros granitos trabalhados de outro modo e suas obras;1;KG
6582;68029910;Esferas para moinho, de outras pedras de cantaria, etc.;1;KG
6583;68029990;Outras pedras de cantaria, etc, trabalhadas de outro modo e obra;1;KG
6584;68030000;Ardosia natural trabalhada e obras de ardosia natural ou aglomerada;1;KG
6585;68041000;Mos para moer ou desfibrar;1;KG
6586;68042111;Mos de diamante natural ou sintetico, aglomerado, de diametro inferior a 53,34 cm, aglomerados com resina;1;KG
6587;68042119;Outros mos de diamante natural ou sintetico, aglomerado, de diametro inferior a 53,34 cm;1;KG
6588;68042190;Outros mos de diamante natural ou sintetico, aglomerado;1;KG
6589;68042211;Mos de outros abrasivos aglomerados ou de ceramica, de diametro inferior a 53,34 cm, aglomerados com resina;1;KG
6590;68042219;Outros mos de outros abrasivos aglomerados ou de ceramica, de diametro inferior a 53,34 cm;1;KG
6591;68042290;Outros mos de outros abrasivos aglomerados ou de ceramica;1;KG
6592;68042300;Outros mos e artefatos semelhantes, de pedras naturais;1;KG
6593;68043000;Pedras para amolar ou para polir, manualmente;1;KG
6594;68051000;Abrasivos naturais ou artificiais, em po ou em graos, aplicados sobre materias texteis, papel, cartao ou outras materias, mesmo recortados, costurados ou reunidos de outro modo, aplicados apenas sobre tecidos de materias texteis;1;KG
6595;68052000;Abrasivos naturais ou artificiais, em po ou em graos, aplicados sobre materias texteis, papel, cartao ou outras materias, mesmo recortados, costurados ou reunidos de outro modo, aplicados apenas sobre papel ou cartao;1;KG
6596;68053010;Abrasivos naturais ou artificiais, com suporte de papel ou cartao combinados com materias texteis;1;KG
6597;68053020;Discos abrasivos de fibra vulcanizada, recobertos com oxido de aluminio ou carboneto de silicio;1;KG
6598;68053090;Outros abrasivos naturais/artificiais em po/graos aplicados sobre outras materias texteis;1;KG
6599;68061000;Las de escorias de altos-fornos, las de outras escorias, la de rocha e las minerais semelhantes, mesmo misturadas entre si, a granel, em folhas ou em rolos;1;KG
6600;68062000;Vermiculita e argilas, expandidas, espuma de escorias e produtos minerais semelhantes, expandidos, mesmo misturados entre si;1;KG
6601;68069010;Produtos minerais aluminosos ou silicoaluminosos;1;KG
6602;68069090;Outras obras de materias minerais para isolamento do calor, som,  etc.;1;KG
6603;68071000;Obras de asfalto ou de produtos semelhantes (por exemplo, breu ou pez), em rolos;1;KG
6604;68079000;Outras obras de asfalto ou de produtos semelhantes (por exemplo, breu ou pez);1;KG
6605;68080000;Paineis, chapas, ladrilhos, blocos e semelhantes, de fibras vegetais, de palha ou de aparas, particulas, serragem ou de outros desperdicios de madeira, aglomerados com cimento, gesso ou outros aglutinantes minerais;1;KG
6606;68091100;Chapas, placas, paineis, ladrilhos e semelhantes, nao ornamentados, revestidos ou reforcados exclusivamente com papel ou cartao, de gesso ou de composicoes a base de gesso;1;KG
6607;68091900;Outras chapas, placas, paineis, ladrilhos e semelhantes, nao ornamentados, de gesso ou de composicoes a base de gesso;1;KG
6608;68099000;Outras obras de gesso ou de composicoes a base de gesso;1;KG
6609;68101100;Blocos e tijolos para a construcao, cimento, de concreto ou de pedra artificial, mesmo armadas;1;KG
6610;68101900;Outras telhas, ladrilhos, semelhantes, de cimento, de concreto ou de pedra artificial, mesmo armadas;1;KG
6611;68109100;Elementos pre-fabricados para a construcao ou engenharia civil, de cimento, de concreto ou de pedra artificial, mesmo armadas;1;KG
6612;68109900;Outras obras de cimento, de concreto ou de pedra artificial, mesmo armadas;1;KG
6613;68114000;Obras de fibrocimento, cimento-celulose ou produtos semelhantes, que contenham amianto;1;KG
6614;68118100;Chapas onduladas de fibrocimento, cimento-celulose, ou produtos semelhantes, que nao contenham amianto;1;KG
6615;68118200;Outras chapas, paineis, ladrilhos, telhas e artigos semelhantes, de fibrocimento, cimento-celulose ou produtos semelhantes;1;KG
6616;68118900;Outras obras de fibrocimento, cimento-celulose, produtos semelhantes;1;KG
6617;68128000;Obras de crocidolita (amianto) ou em fibras;1;KG
6618;68129100;Vestuario, acessorios de vestuario, calcados e chapeus, de amianto/das misturas;1;KG
6619;68129200;Papeis, cartoes, feltros, de amianto/das misturas;1;KG
6620;68129300;Folhas de amianto e elastomeros, comprimidos, para juntas, mesmo apresentadas em rolos;1;KG
6621;68129910;Juntas e outros elementos com funcao semelhante de vedacao, de amianto;1;KG
6622;68129920;Amianto trabalhado, em fibras;1;KG
6623;68129930;Misturas a base de amianto ou a base de amianto e carbonato de magnesio;1;KG
6624;68129990;Outras obras de amianto trabalhado com fibras com mistura a base de amianto com carbonato de magnesio;1;KG
6625;68132000;Guarnicao de friccao;1;KG
6626;68138110;Pastilhas para freios;1;KG
6627;68138190;Outras guarnicoes para freios;1;KG
6628;68138910;Disco de friccao para embreagens, que nao contenham amianto;1;KG
6629;68138990;Outras guarnicoes nao montadas, para embreagens, etc, de amianto;1;KG
6630;68141000;Placas, folhas ou tiras, de mica aglomerada ou reconstituida, mesmo com suporte;1;KG
6631;68149000;Outras obras de mica ou mica trabalhada;1;KG
6632;68151010;Fibras de carbono, para usos nao eletricos;1;KG
6633;68151020;Tecidos de fibras de carbono, para usos nao eletricos;1;KG
6634;68151090;Outras obras de grafita/outros carbonos, para uso nao eletrico;1;KG
6635;68152000;Obras de turfa;1;KG
6636;68159110;Obras que contenham magnesita, dolomita ou cromita, crus, aglomerados com aglutinante quimico;1;KG
6637;68159190;Outras obras contendo magnesita, dolomita ou cromita;1;KG
6638;68159911;Obras de pedras eletrofundidas, com um teor de alumina (Al2O3), superior ou igual a 90 %, em peso;1;KG
6639;68159912;Obras de pedras eletrofundidas, com um teor de silica (SiO2) superior ou igual a 90 %, em peso;1;KG
6640;68159913;Obras de pedras eletrofundidas, com um teor, em peso, de oxido de zirconio (ZrO2) superior ou igual a 50 % mesmo com um conteudo de alumina inferior a 45 %;1;KG
6641;68159914;Obras de pedras eletrofundidas constituidas por mistura/combinacao de alumina (Al2O3), silica (SiO2) e oxido de zirconio (ZrO2), com teor, em peso, de alumina >=  45 % mas < 90 % ou com conteudo, em peso, de oxido de zirconio (ZrO2) >= 20 % mas < 50 %;1;KG
6642;68159919;Outras obras de pedras/materias minerais, eletrofundidas;1;KG
6643;68159990;Outras obras de pedras ou de outras materias minerais;1;KG
6644;69010000;Tijolos, placas (lajes), ladrilhos e outras pecas ceramicas de farinhas siliciosas fosseis (por exemplo, kieselguhr, tripolita, diatomita) ou de terras siliciosas semelhantes;1;KG
6645;69021011;Tijolos ou placas refratarias, contendo, em peso, mais de 90 % de trioxido de dicromo;1;KG
6646;69021018;Outros tijolos refratarios magnesianos ou a base de oxido de cromo;1;KG
6647;69021019;Outras pecas ceramicas refratrarias magnesianas ou a base de oxido de cromo;1;KG
6648;69021090;Outras pecas ceramicas refratarias, que contenham, em peso, mais de 50 % dos elementos Mg, Ca ou Cr, tomados isoladamente ou em conjunto, expressos em MgO, CaO ou Cr2O3;1;KG
6649;69022010;Tijolos silico-aluminosos, refratrarios;1;KG
6650;69022091;Outras pecas ceramicas refratarias silico-aluminosos;1;KG
6651;69022092;Outras pecas ceramicas refratarias silicoso, semi-silicoso ou de silica;1;KG
6652;69022093;Outras pecas ceramicas refratarias de silimanita;1;KG
6653;69022099;Outras pecas ceramicas refrataria, que contenham, em peso, mais de 50 % de alumina (Al2O3), de silica (SiO2) ou de uma mistura ou combinacao destes produtos;1;KG
6654;69029010;Tijolos e outras pecas ceramicas refratarias, de grafita;1;KG
6655;69029020;Tijolos e outras pecas ceramicas refratarias nao fundidos, com um teor de oxido de zirconio (ZrO2) superior a 25 %, em peso;1;KG
6656;69029030;Pecas ceramicas refratarias, com um teor de carbono superior a 85 %, em peso, e diametro medio de poro inferior ou igual a 5 micrometros (microns), do tipo dos utilizados em altos-fornos;1;KG
6657;69029040;Outros tijolos, placas, de carboneto de silicio;1;KG
6658;69029090;Outros tijolos e pecas ceramicas para construcao, refratarios;1;KG
6659;69031011;Cadinhos refratrarios, de grafita;1;KG
6660;69031012;Cadinhos refratrarios, elaborados com uma mistura de grafita e carboneto de silicio;1;KG
6661;69031019;Outros cadinhos refratrarios, que contenham, em peso, mais de 50 % de grafita ou de outro carbono, ou de uma mistura destes produtos;1;KG
6662;69031020;Retortas elaboradas com uma mistura de grafita e carboneto de silicio;1;KG
6663;69031030;Tampas e tampoes, refratarios, de grafita ou outro carbono > 50%;1;KG
6664;69031040;Tubo refratrario, de grafita/outro carbono ou mistura > 50%;1;KG
6665;69031090;Outros produtos ceramicos refratarios de grafita ou outro carbono > 50%;1;KG
6666;69032010;Cadinhos refratrarios, que contenham, em peso, mais de 50 % de alumina (Al2O3) ou de uma mistura ou combinacao de alumina e silica (SiO2);1;KG
6667;69032020;Tampas e tampoes refratarios, que contenham, em peso, mais de 50 % de alumina (Al2O3) ou de uma mistura ou combinacao de alumina e silica (SiO2);1;KG
6668;69032030;Tubos refratrarios, que contenham, em peso, mais de 50 % de alumina (Al2O3) ou de uma mistura ou combinacao de alumina e silica (SiO2);1;KG
6669;69032090;Outros produtos ceramicos refratarios, que contenham, em peso, mais de 50 % de alumina (Al2O3) ou de uma mistura ou combinacao de alumina e silica (SiO2);1;KG
6670;69039011;Tubo refratrario, de carboneto de silicio;1;KG
6671;69039012;Tubo refratrario, de compostos de zirconio;1;KG
6672;69039019;Outros tubos ceramicos refratrarios;1;KG
6673;69039091;Outros produtos ceramicos refratarios de carboneto de silicio;1;KG
6674;69039092;Outros produtos ceramicos refratarios de compostos de zirconio;1;KG
6675;69039099;Outros produtos ceramicos refratrarios;1;KG
6676;69041000;Tijolos de ceramica;1;1000UN
6677;69049000;Tijoleiras e outros produtos para construcao, de ceramica;1;KG
6678;69051000;Telhas de ceramica;1;KG
6679;69059000;Outros produtos ceramicos para construcao;1;KG
6680;69060000;Tubos, calhas ou algerozes e acessorios para canalizacoes, de ceramica;1;KG
6681;69072100;Ladrilhos e placas (lajes), para pavimentacao ou revestimento, exceto os das subposicoes 6907.30 e 6907.40, com um coeficiente de absorcao de agua, em peso, nao superior a 0,5 %;1;M2
6682;69072200;Ladrilhos e placas (lajes), para pavimentacao ou revestimento, exceto os das subposicoes 6907.30 e 6907.40, com um coeficiente de absorcao de agua, em peso, superior a 0,5 %, mas nao superior a 10 %;1;M2
6683;69072300;Ladrilhos e placas (lajes), para pavimentacao ou revestimento, exceto os das subposicoes 6907.30 e 6907.40, com um coeficiente de absorcao de agua, em peso, superior a 10 %;1;M2
6684;69073000;Cubos, pastilhas e artigos semelhantes, para mosaicos, exceto os da subposicao 6907.40;1;M2
6685;69074000;Pecas de acabamento, de ceramica;1;M2
6686;69091100;Aparelhos e artefatos para usos quimicos ou para outros usos tecnicos, de porcelana;1;KG
6687;69091210;Guia-fios para maquinas texteis, com uma dureza equivalente a 9 ou mais na escala de Mohs;1;KG
6688;69091220;Guias de agulhas para cabecas de impressao, com uma dureza equivalente a 9 ou mais na escala de Mohs;1;KG
6689;69091230;Aneis de carboneto de silicio para juntas de vedacao mecanicas, com uma dureza equivalente a 9 ou mais na escala de Mohs;1;KG
6690;69091290;Outros artefatos de ceramica, exceto porcelana, com uma dureza equivalente a 9 ou mais na escala de Mohs;1;KG
6691;69091910;Outros guia-fios para maquinas texteis, de ceramica, exceto porcelana;1;KG
6692;69091920;Outros guias de agulhas para cabecas de impressao, de outras ceramicas;1;KG
6693;69091930;Colmeia de ceramica a base de alumina (Al2O3), silica (SiO2) e oxido de magnesio (MgO), de depuradores por conversao catalitica de gases de escape de veiculos;1;KG
6694;69091990;Outros aparelhos e artefatos de ceramica, para uso quimico/tecnico;1;KG
6695;69099000;Alguidares e outros recipientes de ceramica para uso rural, etc.;1;KG
6696;69101000;Pias, lavatorios, etc, para sanitarios, de porcelana;1;UN
6697;69109000;Pias, lavatorios, etc, para sanitarios, de ceramica, exceto porcelana;1;UN
6698;69111010;Conjunto (jogo ou aparelho) para jantar, cafe ou cha, apresentado em embalagem comum, de porcelana;1;KG
6699;69111090;Outros artigos para servicos de mesa/cozinha, de porcelana;1;KG
6700;69119000;Outros artigos de uso domestico, higiene, etc, de porcelana;1;KG
6701;69120000;Louca, outros artigos de uso domestico e artigos de higiene ou de toucador, de ceramica, exceto de porcelana;1;KG
6702;69131000;Estatuetas/outros objetos ornamentais .de porcelana;1;KG
6703;69139000;Estatuetas/outros objetos ornamentais de ceramica, exceto porcelana;1;KG
6704;69141000;Outras obras de porcelana;1;KG
6705;69149000;Outras obras de ceramica, exceto porcelana;1;KG
6706;70010000;Cacos, fragmentos e outros desperdicios e residuos de vidro, vidro em blocos ou massas;1;KG
6707;70021000;Esferas de vidro, nao trabalhado;1;KG
6708;70022000;Barras ou varetas, de vidro, nao trabalhado;1;KG
6709;70023100;Tubos de vidro, de quartzo ou de outras silicas fundidos, nao trabalhado;1;KG
6710;70023200;Tubos de outro vidro com um coeficiente de dilatacao linear nao superior a 5x10-6 por Kelvin, entre 0 �C e 300 �C, nao trabalhado;1;KG
6711;70023900;Tubos de outros vidros, nao trabalhados;1;KG
6712;70031200;Chapas/folhas nao armadas, de vidro vazado/laminado, coradas, etc;1;M2
6713;70031900;Outras chapas e folhas, nao armadas, de vidro vazado/laminado;1;M2
6714;70032000;Chapas/folhas armadas, de vidro vazado/laminado;1;M2
6715;70033000;Perfis de vidro vazado ou laminado;1;M2
6716;70042000;Folhas de vidro estirado/soprado, corado na massa, etc.;1;M2
6717;70049000;Outras folhas de vidro estirado ou soprado;1;M2
6718;70051000;Vidro nao armado, com camada absorvente, refletora ou nao, em chapas ou em folhas;1;M2
6719;70052100;Outro vidro nao armado, corado na massa, opacificado, folheado (chapeado) ou simplesmente desbastado, em chapas ou folhas;1;M2
6720;70052900;Outras chapas/folhas de vidro flotado, desbastado, etc, nao armado;1;M2
6721;70053000;Chapas/folhas de vidro flotado e desbastado/polido, armadas;1;M2
6722;70060000;Vidro das posicoes 70.03, 70.04 ou 70.05, recurvado, biselado, gravado, brocado, esmaltado ou trabalhado de outro modo, mas nao emoldurado nem associado a outras materias;1;KG
6723;70071100;Vidros temperados, de seguranca, de dimensoes e formatos que permitam a sua aplicacao em automoveis, veiculos aereos, barcos ou outros veiculos;1;UN
6724;70071900;Outros vidros de seguranca, temperados;1;M2
6725;70072100;Vidros de seguranca, formados por folhas contracoladas, de dimensoes e formatos que permitam a sua aplicacao em automoveis, veiculos aereos, barcos ou outros veiculos;1;UN
6726;70072900;Outros vidros de seguranca, de folhas contracoladas;1;M2
6727;70080000;Vidros isolantes de paredes multiplas;1;KG
6728;70091000;Espelhos retrovisores para veiculos;1;KG
6729;70099100;Espelhos de vidro, nao emoldurados;1;KG
6730;70099200;Espelhos de vidro, emoldurados;1;KG
6731;70101000;Ampolas de vidro proprias para transporte ou embalagem;1;KG
6732;70102000;Rolhas, tampas e outros dispositivos de uso semelhante, de vidro;1;KG
6733;70109011;Garrafoes e garrafas, de vidro, de capacidade superior a 1 l;1;KG
6734;70109012;Frascos, boioes, vasos, embalagens tubulares e outros recipientes proprios para transporte ou embalagem, boioes para conservas, de vidro, capacidade > 1 litro;1;KG
6735;70109021;Garrafoes e garrafas, de vidro, de capacidade superior a 0,33 l mas nao superior a 1 l;1;KG
6736;70109022;Frascos, boioes, vasos, embalagens tubulares e outros recipientes proprios para transporte ou embalagem, boioes para conservas, de vidro, de capacidade superior a 0,33 l mas nao superior a 1 l;1;KG
6737;70109090;Outros garrafoes, garrafas, frascos, etc, de vidro;1;KG
6738;70111010;Ampolas de vidro, etc, para lampadas ou tubos de descarga, incluindo os de luz-relampago (flash);1;KG
6739;70111021;Bulbos de diametro inferior ou igual a 90 mm, de vidro, para lampadas de incandescencia;1;KG
6740;70111029;Ampolas de vidro, etc, para lampadas de incandescencia;1;KG
6741;70111090;Outras ampolas, etc, de vidro, para iluminacao eletrica;1;KG
6742;70112000;Ampolas de vidro, etc, para tubos catodicos;1;KG
6743;70119000;Outras ampolas/involucros, abertos, de vidro, suas partes;1;KG
6744;70131000;Objetos de vitroceramica, para servicos de mesa, cozinha,  etc.;1;KG
6745;70132200;Copos de cristal de chumbo, exceto de vitroceramica, com pe;1;KG
6746;70132800;Outros copos de cristal de chumbo, exceto de vitroceramica, com pe;1;KG
6747;70133300;Outros copos, exceto de vitroceramica, de cristal de chumbo;1;KG
6748;70133700;Outros copos de vidro exceto de vitroceramica;1;KG
6749;70134100;Objetos para servico de mesa (exceto copos) ou de cozinha, exceto de vitroceramica, de cristal de chumbo;1;KG
6750;70134210;Cafeteiras e chaleiras, de vidro com um coeficiente de dilatacao linear nao superior a 5x10-6 por Kelvin, entre 0 �C e 300 �C;1;KG
6751;70134290;Outros objetos de vidro para servico de mesa/cozinha, dilatacao nao superior a 5x10-6 kelvin;1;KG
6752;70134900;Outros objetos para servicos de mesa e cozinha, exceto aqueles citados anteriormente;1;KG
6753;70139110;Objetos de cristal de chumbo, para ornamentacao de interiores;1;KG
6754;70139190;Outros objetis de cristal de chumbo, para toucador/escritorio;1;KG
6755;70139900;Outros objetos de vidro, para toucador, escritorio,  etc.;1;KG
6756;70140000;Artefatos de vidro para sinalizacao e elementos de optica de vidro (exceto os da posicao 70.15), nao trabalhados opticamente;1;KG
6757;70151010;Vidro para lentes corretivas, fotocromatico, nao trabalhado opticamente;1;KG
6758;70151091;Vidro para lentes corretivas, branco, nao trabalhado opticamente;1;KG
6759;70151092;Vidro para lentes corretivas, colorido, nao trabalhado opticamente;1;KG
6760;70159010;Vidro para relogios;1;KG
6761;70159020;Vidro para mascaras, oculos ou anteparos, protetores;1;KG
6762;70159030;Vidro para os demais oculos;1;KG
6763;70159090;Outros vidros para aparelhos semelhantes a relogio, esferas de vidro, etc;1;KG
6764;70161000;Cubos, pastilhas e outros artigos semelhantes de vidro, mesmo com suporte, para mosaicos ou decoracoes semelhantes;1;KG
6765;70169000;Blocos, etc, de vidro prensado/moldado, para construcao, etc.;1;KG
6766;70171000;Artefatos de quartzo ou de outras silicas, fundidos, para laboratorio, etc.;1;KG
6767;70172000;Artefatos de outro vidro com um coeficiente de dilatacao linear nao superior a 5x10-6 por Kelvin, entre 0 �C e 300 �C, para laboratorio, etc;1;KG
6768;70179000;Outros artefatos de vidro, para laboratorio, higiene e farmacia;1;KG
6769;70181010;Contas de vidro;1;KG
6770;70181020;Imitacoes de perolas naturais ou cultivadas, pedras preciosas ou semipreciosas, de vidro;1;KG
6771;70181090;Outros artefatos de vidro semelhantes a imitacao de pedras preciosas;1;KG
6772;70182000;Microsferas de vidro, de diametro nao superior a 1 mm;1;KG
6773;70189000;Outras obras e objetos de ornamentacao, de vidro;1;KG
6774;70191100;Fios de fibra de vidro cortados (chopped strands), de comprimento nao superior a 50 mm;1;KG
6775;70191210;Mechas de vidro, impregnadas ou recobertas com resina de poliuretano ou borracha de estireno-butadieno;1;KG
6776;70191290;Outras mechas de vidro, ligeiramente torcidas;1;KG
6777;70191900;Outras mechas e fios, de fibras de vidro;1;KG
6778;70193100;Esteiras (mats), de fibras de vidro, nao tecidos;1;KG
6779;70193200;Veus de fibras de vidro, nao tecidos;1;KG
6780;70193900;Mantas, colchoes, etc, de fibras de vidro, nao tecidos;1;KG
6781;70194000;Tecidos de mechas ligeiramente torcidas (rovings), de fibras de vidro;1;KG
6782;70195100;Tecidos de fibras de vidro, de largura nao superior a 30 cm;1;KG
6783;70195210;Tecidos de fibras de vidro, com um teor de materia organica superior ou igual a 0,075 % e inferior ou igual a 0,3 %, em peso, segundo Norma ANSI/IPC-EG-140, proprios para fabricacao de placas para circuitos impressos;1;KG
6784;70195290;Outros tecidos de fibras de vidro, de largura superior a 30 cm, em ponto de tafeta, com peso inferior a 250 g/m2, de filamentos de titulo nao superior a 136 tex, por fio simples;1;KG
6785;70195900;Outros tecidos de fibras de vidro;1;KG
6786;70199010;Outras fibras com fios paralelos e superpostos angulo 90� 3>= d <= 7 fios cm2;1;KG
6787;70199090;Outras fibras de vidro e suas obras;1;KG
6788;70200010;Ampolas de vidro para garrafa termica, outros recipientes isotermicos;1;KG
6789;70200090;Outras obras de vidro nao especificadas;1;KG
6790;71011000;Perolas naturais, nao montadas, nem engastadas;1;G
6791;71012100;Perolas cultivadas, em bruto, nao montadas, nem engastadas;1;G
6792;71012200;Perolas cultivadas, trabalhadas, nao montadas, nao engastadas;1;G
6793;71021000;Diamantes, mesmo trabalhados, mas nao montados nem engastados, nao selecionados;1;QUILAT
6794;71022100;Diamantes industriais, em bruto ou simplesmente serrados, clivados ou desbastados;1;QUILAT
6795;71022900;Outros diamantes industriais, nao montados, nem engastados;1;QUILAT
6796;71023100;Diamantes nao industriais, em bruto ou simplesmente serrados, clivados ou desbastados;1;QUILAT
6797;71023900;Outros diamantes nao industriais, nao montados, nao engastados;1;QUILAT
6798;71031000;Pedras preciosas (exceto diamantes) ou semipreciosas, em bruto ou simplesmente serradas ou desbastadas;1;KG
6799;71039100;Rubis, safiras e esmeraldas, trabalhadas de outro modo;1;QUILAT
6800;71039900;Outras pedras preciosas (exceto diamantes) ou semipreciosas, trabalhadas de outro modo;1;QUILAT
6801;71041000;Quartzo piezoeletrico;1;KG
6802;71042010;Diamantes sinteticos/reconstituidos, em bruto ou simplesmente serradas ou desbastadas;1;KG
6803;71042090;Outras pedras sinteticas/reconstituidas, em bruto/serrados/desbastados;1;KG
6804;71049000;Outras pedras sinteticas/reconstituidas, mesmo trabalhadas/combinadas;1;KG
6805;71051000;Po de diamantes;1;QUILAT
6806;71059000;Po de pedras preciosas ou semipreciosas ou de pedras sinteticas;1;KG
6807;71061000;Pos de prata;1;KG
6808;71069100;Prata, em formas brutas;1;KG
6809;71069210;Prata,em barras, fios e perfis de secao macica;1;KG
6810;71069220;Prata, em chapas, laminas, folhas e tiras;1;KG
6811;71069290;Prata, em outras formas semimanufaturadas;1;KG
6812;71070000;Metais comuns folheados ou chapeados (plaque) de prata, em formas brutas ou semimanufaturadas;1;KG
6813;71081100;Pos de ouro (incluindo o ouro platinado), para usos nao monetarios;1;KG
6814;71081210;Bulhao dourado (bullion dore), em formas brutas, para uso nao monetario;1;KG
6815;71081290;Ouro em outras formas brutas, para uso nao monetario;1;KG
6816;71081310;Ouro em barras, fios e perfis de secao macica;1;KG
6817;71081390;Ouro em outras formas semimanufaturadas, bulhao dourado, uso nao monetario;1;KG
6818;71082000;Ouro (incluindo o ouro platinado), em formas brutas ou semimanufaturadas, para uso monetario;1;KG
6819;71090000;Metais comuns ou prata, folheados ou chapeados (plaque) de ouro, em formas brutas ou semimanufaturadas;1;KG
6820;71101100;Platina, em formas brutas ou em po;1;KG
6821;71101910;Platina, em barras, fios e perfis de secao macica;1;KG
6822;71101990;Platina, em outras formas semimanufaturadas;1;KG
6823;71102100;Paladio em formas brutas ou em po;1;KG
6824;71102900;Paladio em formas semimanufaturadas;1;KG
6825;71103100;Rodio em formas brutas ou em po;1;KG
6826;71103900;Rodio em formas semimanufaturadas;1;KG
6827;71104100;Iridio, osmio e rutenio, em formas brutas ou em po;1;KG
6828;71104900;Iridio, osmio e rutenio, em formas semimanufaturadas;1;KG
6829;71110000;Metais comuns, prata ou ouro, folheados ou chapeados (plaque) de platina, em formas brutas ou semimanufaturadas;1;KG
6830;71123010;Cinzas que contenham ouro, mas que nao contenham outros metais preciosos;1;KG
6831;71123020;Cinzas que contenham platina, mas que nao contenham outros metais preciosos;1;KG
6832;71123090;Cinzas contendo outros metais preciosos, seus compostos;1;KG
6833;71129100;Outros residuos/desperdicios de ouro, de metais folheados ou chapeados (plaque) de ouro, exceto varreduras que contenham outros metais preciosos;1;KG
6834;71129200;Outros residuos/desperdicios de platina, de metais folheados ou chapeados (plaque) de platina, exceto varreduras que contenham outros metais preciosos;1;KG
6835;71129900;Outros residuos/desperdicios, de outros metais preciosos, etc;1;KG
6836;71131100;Artefatos de joalharia, de prata, mesmo revestida, folheada ou chapeada de outros metais preciosos (plaque);1;KG
6837;71131900;Artefatos de joalharia, de outros metais preciosos, mesmo revestidos, folheados ou chapeados de metais preciosos (plaque);1;KG
6838;71132000;Artefatos de joalharia, de metais comuns folheados ou chapeados de metais preciosos (plaque);1;KG
6839;71141100;Artefatos de ourivesaria, de prata, mesmo revestida, folheada ou chapeada de outros metais preciosos (plaque);1;KG
6840;71141900;Artefatos de ourivesaria, de outros metais preciosos, mesmo revestidos, folheados ou chapeados de metais preciosos (plaque);1;KG
6841;71142000;Artefatos de ourivesaria, de metais comuns folheados ou chapeados de metais preciosos (plaque);1;KG
6842;71151000;Telas ou grades catalisadoras, de platina;1;KG
6843;71159000;Outras obras de metais preciosos, metais folheados/chapeados preciosos;1;KG
6844;71161000;Obras de perolas naturais ou cultivadas;1;KG
6845;71162010;Obras de diamantes sinteticos;1;KG
6846;71162020;Guias de agulhas, de rubi, para cabecas de impressao;1;KG
6847;71162090;Outras obras de pedras preciosas/semi, sintetica/reconstituida;1;KG
6848;71171100;Abotoaduras e artefatos semelhantes, de metais comuns, mesmo prateados, dourados ou platinados;1;KG
6849;71171900;Outras bijuterias de metais comuns;1;KG
6850;71179000;Outras bijuterias;1;KG
6851;71181010;Moedas destinadas a ter curso legal no pais importador;1;KG
6852;71181090;Outras moedas sem curso legal, exceto de ouro;1;KG
6853;71189000;Outras moedas;1;KG
6854;72011000;Ferro fundido bruto nao ligado, que contenha, em peso, 0,5 % ou menos de fosforo;1;KG
6855;72012000;Ferro fundido bruto nao ligado, que contenha, em peso, mais de 0,5 % de fosforo;1;KG
6856;72015000;Ligas de ferro fundido bruto, ferro spiegel (especular);1;KG
6857;72021100;Ferro-manganes, que contenham, em peso, mais de 2 % de carbono;1;KG
6858;72021900;Outras ligas de ferro-manganes;1;KG
6859;72022100;Ferro-silicio, que contenham, em peso, mais de 55 % de silicio;1;KG
6860;72022900;Outras ligas de ferro-silicio;1;KG
6861;72023000;Ferro-silicio-manganes;1;KG
6862;72024100;Ferro-cromo, que contenham, em peso, mais de 4 % de carbono;1;KG
6863;72024900;Outras ligas de ferro-cromo;1;KG
6864;72025000;Ferro-silicio-cromo;1;KG
6865;72026000;Ferro-niquel;1;KG
6866;72027000;Ferro-molibdenio;1;KG
6867;72028000;Ferro-tungstenio (ferro-volframio) e ferro-silicio-tungstenio (ferro-silicio-volframio);1;KG
6868;72029100;Ferro-titanio e ferro-silicio-titanio;1;KG
6869;72029200;Ferro-vanadio;1;KG
6870;72029300;Ferro-niobio;1;KG
6871;72029910;Ferrofosforo;1;KG
6872;72029990;Outros ferroligas;1;KG
6873;72031000;Produtos ferrosos obtidos por reducao direta dos minerios de ferro;1;KG
6874;72039000;Outros produtos ferrosos esponjosos, em pedacos, esferas,  etc;1;KG
6875;72041000;Desperdicios e residuos de ferro fundido;1;KG
6876;72042100;Desperdicios e residuos de acos inoxidaveis;1;KG
6877;72042900;Desperdicios e residuos de outras ligas de aco;1;KG
6878;72043000;Desperdicios e residuos de ferro ou aco, estanhados;1;KG
6879;72044100;Residuos do torno e da fresa, aparas, lascas (meulures), po de serra, limalhas e desperdicios da estampagem ou do corte, mesmo em fardos;1;KG
6880;72044900;Outros desperdicios e residuos de ferro ou aco;1;KG
6881;72045000;Desperdicios de ferro ou aco em lingotes;1;KG
6882;72051000;Granalhas, de ferro fundido bruto, de ferro spiegel (especular), de ferro ou aco;1;KG
6883;72052100;Pos de ligas de aco;1;KG
6884;72052910;Pos de ferro esponjoso, com um teor de ferro superior ou igual a 98 %, em peso;1;KG
6885;72052920;Pos de ferro revestido com resina termoplastica, com um teor de ferro superior ou igual a 98 %, em peso;1;KG
6886;72052990;Outros pos de ferro fundido bruto, de ferro spiegel (especular), de ferro ou aco;1;KG
6887;72061000;Ferro e acos, em lingotes;1;KG
6888;72069000;Ferro e acos nao ligados ou em outras formas primarias;1;KG
6889;72071110;Billets de ferro ou aco nao ligado, de secao transversal quadrada ou retangular, com largura inferior a duas vezes a espessura, que contenham, em peso, menos de 0,25 % de carbono;1;KG
6890;72071190;Outros produtos semimanufaturados de ferro ou aco nao ligado, de secao transversal quadrada ou retangular, com largura inferior a duas vezes a espessura, que contenham, em peso, menos de 0,25 % de carbono;1;KG
6891;72071200;Outros produtos semimanufaturados de ferro ou aco nao ligado, de secao transversal retangular, que contenham, em peso, menos de 0,25 % de carbono;1;KG
6892;72071900;Outros produtos semimanufaturados de ferro ou aco nao ligado, que contenham, em peso, menos de 0,25 % de carbono;1;KG
6893;72072000;Produtos semimanufaturados de ferro ou aco nao ligado, que contenham, em peso, 0,25 % ou mais de carbono;1;KG
6894;72081000;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, laminados a quente, nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente, apresentando motivos em relevo;1;KG
6895;72082500;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, em rolos, simplesmente laminados a quente, decapados, de espessura igual ou superior a 4,75 mm;1;KG
6896;72082610;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, em rolos, simplesmente laminados a quente, decapados, de espessura >= 3 mm, mas inferior a 4,75 mm, com um limite minimo de elasticidade de 355 MPa;1;KG
6897;72082690;Outros laminados de ferro ou aco, largura >= 600 mm, quente, em rolos, decapados, de espessura igual ou superior a 3 mm, mas inferior a 4,75 mm;1;KG
6898;72082710;Laminados de ferro/aco, quente, de largura igual ou superior a 600 mm, em rolos, de espessura inferior a 3 mm, com um limite minimo de elasticidade de 275 MPa;1;KG
6899;72082790;Outros laminados de ferro/aco, quente, de largura igual ou superior a 600 mm, em rolos, de espessura inferior a 3 mm;1;KG
6900;72083610;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente, de espessura > 10 mm, com um limite minimo de elasticidade de 355 MPa;1;KG
6901;72083690;Outros laminados de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, a quente, em rolos, de espessura superior a 10 mm;1;KG
6902;72083700;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, laminados a quente, nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente, de espessura >= 4,75 mm, mas nao superior a 10 mm;1;KG
6903;72083810;Produtos laminados planos, de ferro ou aco nao ligado, de largura >= 600 mm,nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente, de espessura >= 3 mm,mas inferior a 4,75 mm, com um limite minimo de elasticidade de 355 Mpa;1;KG
6904;72083890;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente, de espessura >= 3 mm, mas inferior a 4,75 mm;1;KG
6905;72083910;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm,nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente,de espessura inferior a 3 mm,com um limite minimo de elasticidade de 275 MPa;1;KG
6906;72083990;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos, simplesmente laminados a quente, de espessura inferior a 3 mm;1;KG
6907;72084000;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a quente, apresentando motivos em relevo;1;KG
6908;72085100;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a quente, de espessura superior a 10 mm;1;KG
6909;72085200;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a quente, de espessura igual ou superior a 4,75 mm, mas nao superior a 10 mm;1;KG
6910;72085300;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a quente, de espessura igual ou superior a 3 mm, mas inferior a 4,75 mm;1;KG
6911;72085400;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a quente, de espessura inferior a 3 mm;1;KG
6912;72089000;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, laminados a quente, nao folheados ou chapeados, nem revestidos;1;KG
6913;72091500;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos simplesmente laminados a frio, de espessura igual ou superior a 3 mm;1;KG
6914;72091600;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos simplesmente laminados a frio, de espessura superior a 1 mm, mas inferior a 3 mm;1;KG
6915;72091700;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos simplesmente laminados a frio, de espessura igual ou superior a 0,5 mm, mas nao superior a 1 mm;1;KG
6916;72091800;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, em rolos simplesmente laminados a frio, de espessura inferior a 0,5 mm;1;KG
6917;72092500;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a frio, de espessura igual ou superior a 3 mm;1;KG
6918;72092600;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados simplesmente laminados a frio, de espessura superior a 1 mm, mas inferior a 3 mm;1;KG
6919;72092700;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a frio, de espessura igual ou superior a 0,5 mm, mas nao superior a 1 mm;1;KG
6920;72092800;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a frio, de espessura inferior a 0,5 mm;1;KG
6921;72099000;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, nao folheados ou chapeados, nem revestidos, nao enrolados, simplesmente laminados a frio;1;KG
6922;72101100;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, estanhados, de espessura igual ou superior a 0,5 mm;1;KG
6923;72101200;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, estanhados, de espessura inferior a 0,5 mm;1;KG
6924;72102000;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, estanhados, revestidos de chumbo, incluindo os revestidos de uma liga de chumbo-estanho;1;KG
6925;72103010;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados eletroliticamente, de espessura inferior a 4,75 mm;1;KG
6926;72103090;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados eletroliticamente;1;KG
6927;72104110;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados por outro processo, ondulados, de espessura inferior a 4,75 mm;1;KG
6928;72104190;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados por outro processo, ondulados;1;KG
6929;72104910;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados por outro processo, de espessura inferior a 4,75 mm;1;KG
6930;72104990;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados por outro processo;1;KG
6931;72105000;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, revestidos de oxidos de cromo ou de cromo e oxidos de cromo;1;KG
6932;72106100;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, revestidos de ligas de aluminio-zinco;1;KG
6933;72106911;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura >= 600 mm, revestidos de ligas de aluminio-silicio, com peso superior ou igual a 120 g/m2 e com conteudo de silicio superior ou igual a 5 % porem inferior ou igual a 11 %, em peso;1;KG
6934;72106919;Outros laminados planos, de ferro ou aco nao ligado, revestidos de ligas de aluminio-silicio;1;KG
6935;72106990;Outros laminados de ferro/aco;1;KG
6936;72107010;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, pintados ou envernizados;1;KG
6937;72107020;Produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, revestidos de plasticos;1;KG
6938;72109000;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura igual ou superior a 600 mm, folheados ou chapeados, ou revestidos;1;KG
6939;72111300;Produtos laminados planos, de ferro ou aco nao ligado, largura < 600 mm,nao folheados ou chapeados,nem revestidos,laminados a quente, laminados nas quatro faces ou em caixa fechada,l > 150 mm e esp. >= 4 mm,n/enrolados e n/apresentando motivos em relevo;1;KG
6940;72111400;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos, simplesmente laminados a quente, de espessura igual ou superior a 4,75 mm;1;KG
6941;72111900;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos, simplesmente laminados a quente;1;KG
6942;72112300;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos, simplesmente laminados a frio, que contenham, em peso, menos de 0,25 % de carbono;1;KG
6943;72112910;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos, simplesmente laminados a frio, com um teor de carbono superior ou igual a 0,25 %, mas inferior a 0,6 %, em peso;1;KG
6944;72112920;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos, simplesmente laminados a frio, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6945;72119010;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6946;72119090;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, nao folheados ou chapeados, nem revestidos;1;KG
6947;72121000;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, ou revestidos, estanhados;1;KG
6948;72122010;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados eletroliticamente, de espessura inferior a 4,75 mm;1;KG
6949;72122090;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados eletroliticamente;1;KG
6950;72123000;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, ou revestidos, galvanizados por outro processo;1;KG
6951;72124010;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, pintados ou envernizados;1;KG
6952;72124021;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, revestidos de plasticos, com uma camada intermediaria de liga cobre-estanho ou cobre-estanho-chumbo, aplicada por sinterizacao;1;KG
6953;72124029;Outros produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados, revestidos de plasticos;1;KG
6954;72125010;Produtos laminados planos, de ferro ou aco nao ligado, de largura < 600 mm,revestidos com uma camada de liga cobre-estanho ou cobre-estanho-chumbo,aplicada por sinterizacao,inclusive com revestimento misto metal-plastico ou metal-plastico-fibra de carbono;1;KG
6955;72125090;Outros laminados de ferro ou aco, largura < 60 cm,  revestido de outras materias;1;KG
6956;72126000;Produtos laminados planos, de ferro ou aco nao ligado, de largura inferior a 600 mm, folheados ou chapeados;1;KG
6957;72131000;Fio-maquina de ferro ou aco nao ligado, dentados, com nervuras, sulcos ou relevos, obtidos durante a laminagem;1;KG
6958;72132000;Fio-maquina de acos para tornear;1;KG
6959;72139110;Fio-maquina de ferro ou aco nao ligado, de secao circular, de diametro inferior a 14 mm, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6960;72139190;Outros fios-maquinas de ferro ou aco nao ligado, de secao circular, de diametro inferior a 14 mm;1;KG
6961;72139910;Outros fios-maquina de ferro ou aco nao ligado, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6962;72139990;Outros fios-maquina de ferro ou aco nao ligado;1;KG
6963;72141010;Barras de ferro ou aco nao ligado, forjadas, a quente, com um teor de carbono inferior ou igual a 0,6 %, em peso;1;KG
6964;72141090;Outras barras de ferro ou aco nao ligado, forjadas, a quente;1;KG
6965;72142000;Barras de ferro ou aco nao ligado, a quente, dentadas, com nervuras, sulcos ou relevos, obtidos durante a laminagem, ou torcidas apos laminagem;1;KG
6966;72143000;Barras de acos para tornear, laminadas, etc. a quente;1;KG
6967;72149100;Barras de ferro ou aco nao ligado, laminadas, etc, quente, de secao transversal retangular;1;KG
6968;72149910;Barras de ferro ou aco nao ligado, laminadas a quente, de secao circular;1;KG
6969;72149990;Outras barras de ferro ou aco nao ligado, laminadas a quente, etc;1;KG
6970;72151000;Barras de acos para tornear, simplesmente obtidas ou completamente acabadas a frio;1;KG
6971;72155000;Outras barras de ferro ou aco nao ligado, simplesmente obtidas ou completamente acabadas a frio;1;KG
6972;72159010;Outras barras de ferro ou aco nao ligado, com um teor de carbono inferior ou igual a 0,6 %, em peso;1;KG
6973;72159090;Outras barras de ferro ou aco nao ligado;1;KG
6974;72161000;Perfis de ferro ou aco nao ligado, em U, I ou H, simplesmente laminados, estirados ou extrudados, a quente, de altura inferior a 80 mm;1;KG
6975;72162100;Perfis de ferro ou aco nao ligado, em L, simplesmente laminados, estirados ou extrudados, a quente, de altura inferior a 80 mm;1;KG
6976;72162200;Perfis de ferro ou aco nao ligado, em T, simplesmente laminados, estirados ou extrudados, a quente, de altura inferior a 80 mm;1;KG
6977;72163100;Perfis de ferro ou aco nao ligado, em U, simplesmente laminados, estirados ou extrudados, a quente, de altura igual ou superior a 80 mm;1;KG
6978;72163200;Perfis de ferro ou aco nao ligado, em I, simplesmente laminados, estirados ou extrudados, a quente, de altura igual ou superior a 80 mm;1;KG
6979;72163300;Perfis de ferro ou aco nao ligado, em H, simplesmente laminados, estirados ou extrudados, a quente, de altura igual ou superior a 80 mm;1;KG
6980;72164010;Perfis de ferro ou aco nao ligado, em L ou T, simplesmente laminados, estirados ou extrudados, a quente, de altura inferior ou igual a 200 mm;1;KG
6981;72164090;Outros perfis de ferro ou aco nao ligado, em L ou T, simplesmente laminados, estirados ou extrudados, a quente, de altura igual ou superior a 80 mm;1;KG
6982;72165000;Outros perfis, simplesmente laminados, estirados ou extrudados, a quente;1;KG
6983;72166110;Perfis simplesmente obtidos ou completamente acabados a frio, obtidos a partir de produtos laminados planos, de altura inferior a 80 mm;1;KG
6984;72166190;Outros perfis simplesmente obtidos ou completamente acabados a frio, obtidos a partir de produtos laminados planos;1;KG
6985;72166910;Outros perfis de ferro ou aco nao ligado, obtidos ou completamente acabados a frio, de altura inferior a 80 mm;1;KG
6986;72166990;Outros perfis de ferro ou aco nao ligado, obtidos ou completamente acabados a frio;1;KG
6987;72169100;Outros perfis de ferro ou aco nao ligado, obtidos ou acabados a frio a partir de produtos laminados planos;1;KG
6988;72169900;Outros perfis de ferro/aco, nao ligados;1;KG
6989;72171011;Fios de ferro ou aco nao ligado, nao revestidos, mesmo polidos, com um teor de carbono >=0,6 %, em peso, com um teor, em peso, de fosforo < 0,035 % e de enxofre < 0,035 %, temperado e revenido, flexa maxima sem carga de 1 cm em 1 m, etc...;1;KG
6990;72171019;Outros fios de ferro ou aco nao ligado, nao revestidos, mesmo polidos, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6991;72171090;Outros fios de ferro ou aco nao ligado, nao revestidos;1;KG
6992;72172010;Fios de ferro ou aco nao ligado, galvanizados, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6993;72172090;Outros fios de ferro ou aco nao ligado, galvanizados;1;KG
6994;72173010;Fios de ferro ou aco nao ligado, revestidos de outros metais comuns, com um teor de carbono superior ou igual a 0,6 %, em peso;1;KG
6995;72173090;Outros fios de ferro ou aco nao ligado, revestidos de outros metais comuns;1;KG
6996;72179000;Outros fios de ferro/aco, nao ligados;1;KG
6997;72181000;Acos inoxidaveis, em lingotes e outras formas primarias;1;KG
6998;72189100;Produtos semimanufaturados, de acos inoxidaveis, secao transversal retangular;1;KG
6999;72189900;Outros produtos semimanufaturados, de acos inoxidaveis;1;KG
7000;72191100;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, em rolos, de espessura superior a 10 mm;1;KG
7001;72191200;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, em rolos, de espessura igual ou superior a 4,75 mm, mas nao superior a 10 mm;1;KG
7002;72191300;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, em rolos, de espessura igual ou superior a 3 mm, mas inferior a 4,75 mm;1;KG
7003;72191400;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, em rolos, de espessura inferior a 3 mm;1;KG
7004;72192100;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, nao enrolados, de espessura superior a 10 mm;1;KG
7005;72192200;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, nao enrolados, de espessura igual ou superior a 4,75 mm, mas nao superior a 10 mm;1;KG
7006;72192300;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, nao enrolados, de espessura igual ou superior a 3 mm, mas inferior a 4,75 mm;1;KG
7007;72192400;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a quente, nao enrolados, de espessura inferior a 3 mm;1;KG
7008;72193100;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a frio, de espessura igual ou superior a 4,75 mm;1;KG
7009;72193200;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a frio, de espessura igual ou superior a 3 mm, mas inferior a 4,75 mm;1;KG
7010;72193300;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a frio, de espessura superior a 1 mm, mas inferior a 3 mm;1;KG
7011;72193400;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a frio, de espessura igual ou superior a 0,5 mm, mas nao superior a 1 mm;1;KG
7012;72193500;Produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, simplesmente laminados a frio, de espessura inferior a 0,5 mm;1;KG
7013;72199010;Outros produtos laminados planos de aco inoxidavel, de largura igual ou superior a 600 mm, de espessura inferior a 4,75 mm e dureza superior ou igual a 42 HRC;1;KG
7014;72199090;Outros laminados acos inoxidaveis largura >= 600 mm;1;KG
7015;72201100;Produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm, de espessura igual ou superior a 4,75 mm;1;KG
7016;72201210;Produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm, de espessura inferior ou igual a 1,5 mm;1;KG
7017;72201220;Produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm, de espessura superior a 1,5 mm, mas inferior ou igual a 3 mm;1;KG
7018;72201290;Outros produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm, de espessura superior a 3 mm, mas inferior a 4,75 mm;1;KG
7019;72202010;Produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm, simplesmente laminados a frio, de largura inferior ou igual a 23 mm e espessura inferior ou igual a 0,1 mm;1;KG
7020;72202090;Outros produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm, simplesmente laminados a frio;1;KG
7021;72209000;Outros produtos laminados planos de aco inoxidavel, de largura inferior a 600 mm;1;KG
7022;72210000;Fio-maquina de aco inoxidavel;1;KG
7023;72221100;Barras de aco inoxidavel simplesmente laminadas, estiradas ou extrudadas, a quente, de secao circular;1;KG
7024;72221910;Barras de aco inoxidavel simplesmente laminadas, estiradas ou extrudadas, a quente, de secao transversal retangular;1;KG
7025;72221990;Outras barras de aco inoxidavel simplesmente laminadas, estiradas ou extrudadas, a quente;1;KG
7026;72222000;Barras de aco inxodiavel simplesmente obtidas ou completamente acabadas a frio;1;KG
7027;72223000;Outras barras de acos inoxidaveis;1;KG
7028;72224010;Perfis de aco inoxidavel, de altura superior ou igual a 80 mm;1;KG
7029;72224090;Outros perfis de aco inoxidavel;1;KG
7030;72230000;Fios de aco inoxidavel;1;KG
7031;72241000;Outras ligas de acos, em lingotes e outras formas primarias;1;KG
7032;72249000;Produtos semimanufaturados, de outras ligas de acos;1;KG
7033;72251100;Produtos laminados planos, de outras ligas de aco, de largura igual ou superior a 600 mm, de acos ao silicio, denominados magneticos, de graos orientados;1;KG
7034;72251900;Outros produtos laminados planos, de outras ligas de aco, de largura igual ou superior a 600 mm, de acos ao silicio, denominados magneticos;1;KG
7035;72253000;Laminados de outras ligas de acos, simplesmente laminados a quente, em rolos, de largura igual ou superior a 600 mm;1;KG
7036;72254010;Outros laminados de outras ligas de acos, simplesmente laminados a quente, nao enrolados, de aco, segundo normas AISI D2, D3 ou D6, de espessura inferior ou igual a 7 mm;1;KG
7037;72254020;Laminados planos de acos de corte rapido, de largura igual ou superior a 600 mm;1;KG
7038;72254090;Outros laminados de outras ligas de acos, a quente,  largura >= 600 mm, nao enrolado;1;KG
7039;72255010;Outros laminados planos, simplesmente laminados a frio, de acos de corte rapido, de largura igual ou superior a 600 mm;1;KG
7040;72255090;Outros laminados planos, simplesmente laminados a frio, de largura igual ou superior a 600 mm;1;KG
7041;72259100;Laminados de outras ligas de aco, de largura igual ou superior a 600 mm, galvanizados eletroliticamente;1;KG
7042;72259200;Laminados de outras ligas de aco, de largura igual ou superior a 600 mm, galvanizados por outro processo;1;KG
7043;72259910;Outros laminados planos de acos de corte rapido, de largura igual ou superior a 600 mm;1;KG
7044;72259990;Outros produtos laminados planos de aco, de largura maior ou igual a 600 mm;1;KG
7045;72261100;Produtos laminados planos, de outras ligas de aco, de largura inferior a 600 mm, de acos ao silicio, denominados magneticos, de graos orientados;1;KG
7046;72261900;Outros produtos laminados planos, de outras ligas de aco, de largura inferior a 600 mm, de acos ao silicio, denominados magneticos;1;KG
7047;72262010;Produtos laminados planos, de outras ligas de aco, de largura inferior a 600 mm, de acos de corte rapido, de espessura superior ou igual a 1 mm mas inferior ou igual a 4 mm;1;KG
7048;72262090;Outros produtos laminados planos, de outras ligas de aco, de largura inferior a 600 mm, de acos de corte rapido;1;KG
7049;72269100;Produtos laminados planos, de outras ligas de aco, de largura inferior a 600 mm, simplesmente laminados a quente;1;KG
7050;72269200;Produtos laminados planos, de outras ligas de aco, de largura inferior a 600 mm, simplesmente laminados a frio;1;KG
7051;72269900;Outros laminados de outras ligas de acos, largura < 600 mm;1;KG
7052;72271000;Fio-maquina de outras ligas de aco, de acos de corte rapido;1;KG
7053;72272000;Fio-maquina de outras ligas de aco, de acos silicio-manganes;1;KG
7054;72279000;Outro fio-maquina de outras ligas de aco;1;KG
7055;72281010;Barras de acos de corte rapido, simplesmente laminadas, estiradas ou extrudadas, a quente;1;KG
7056;72281090;Outras barras de ligas acos de corte rapido;1;KG
7057;72282000;Barras de acos silicio-manganes;1;KG
7058;72283000;Barras de outras ligas de acos, simplesmente laminadas, estiradas ou extrudadas, a quente;1;KG
7059;72284000;Barras de outras ligas de acos, simplesmente forjadas;1;KG
7060;72285000;Barras de outras ligas de acos, simplesmente obtidas ou completamente acabadas a frio;1;KG
7061;72286000;Outras barras de outras ligas de acos;1;KG
7062;72287000;Perfis de outras ligas de acos;1;KG
7063;72288000;Barras ocas de ligas de acos, para perfuracao;1;KG
7064;72292000;Fios de ligas de acos silicio-manganes;1;KG
7065;72299000;Fios de outras ligas de acos;1;KG
7066;73011000;Estacas-pranchas de ferro ou aco, mesmo perfuradas ou feitas com elementos montados;1;KG
7067;73012000;Perfis de ferro ou aco, obtidos por soldadura;1;KG
7068;73021010;Trilhos de aco, de peso linear superior ou igual a 44,5 kg/m;1;KG
7069;73021090;Outros trilhos de vias ferreas, de ferro fundido, ferro ou aco;1;KG
7070;73023000;Agulhas, crossimas, alavancas para comando de agulhas e outros elementos de cruzamentos e desvios, de ferro fundido, ferro ou aco;1;KG
7071;73024000;Talas de juncao e placas de apoio ou assentamento, de ferro fundido, ferro ou aco;1;KG
7072;73029000;Outros elementos de vias ferreas, de ferro fundido, ferro ou aco;1;KG
7073;73030000;Tubos e perfis ocos, de ferro fundido;1;KG
7074;73041100;Tubos dos tipos utilizados em oleodutos ou gasodutos, de aco inoxidavel;1;KG
7075;73041900;Outros tubos e perfis ocos, sem costura, de ferro ou aco, dos tipos utilizados em oleodutos ou gasodutos;1;KG
7076;73042200;Hastes de perfuracao de aco inoxidavel, dos tipos utilizados na extracao de petroleo ou de gas, sem costura;1;KG
7077;73042310;Outras hastes de perfuracao de aco nao ligado, dos tipos utilizados na extracao de petroleo ou de gas, sem costura;1;KG
7078;73042390;Outros tubos de perfuracao, sem costura, de ferro ou aco, dos tipos utilizados na extracao de petroleo ou de gas;1;KG
7079;73042400;Outros tubos, dos tipos utilizados na extracao de petroleo ou de gas, de aco inoxidavel;1;KG
7080;73042910;Tubos de aco nao ligado, sem costura, para revestimento de pocos, de producao ou suprimento;1;KG
7081;73042931;Tubos de outras ligas de aco nao revestidos, sem costura, para revestimento de pocos, de diametro exterior inferior ou igual a 229 mm;1;KG
7082;73042939;Outros tubos de ligas de acos, nao revestidos, sem costura, para revestimento de pocos, etc;1;KG
7083;73042990;Outros tubos de ferro fundido, ferro ou aco, sem costura, para revestimento de pocos, etc;1;KG
7084;73043110;Tubos nao revestidos, estirados ou laminados, a frio, de secao circular, de ferro ou aco nao ligado;1;KG
7085;73043190;Outros tubos, estirados ou laminados, a frio, de secao circular, de ferro ou aco nao ligado;1;KG
7086;73043910;Tubos nao revestidos, de diametro exterior inferior ou igual a 229 mm, de secao circular, de ferro ou aco nao ligado;1;KG
7087;73043920;Tubos revestidos, de diametro exterior inferior ou igual a 229 mm, de secao circular, de ferro ou aco nao ligado;1;KG
7088;73043990;Outros tubos de secao circular, de ferro ou aco nao ligado;1;KG
7089;73044110;Tubos capilares de diametro exterior inferior ou igual a 3 mm e diametro interior inferior ou igual a 0,2 mm, estirados ou laminados, a frio;1;KG
7090;73044190;Outros tubos capilares estirados ou laminados, a frio;1;KG
7091;73044900;Outros tubos de acos inoxidaveis, sem costura, secao circular;1;KG
7092;73045111;Tubos capilares de diametro exterior inferior ou igual a 3 mm e diametro interior inferior ou igual a 0,2 mm;1;KG
7093;73045119;Outros tubos de diametro exterior inferior ou igual a 229 mm;1;KG
7094;73045190;Outros tubos de outras ligas de acos, sem costura, secao circular, laminados a frio;1;KG
7095;73045911;Tubos de diametro exterior inferior ou igual a 229 mm, com um teor,em peso,de carbono >= 0,98 % e <= 1,10 %, de cromo >= 1,30 % e <= 1,60 %, de silicio >= 0,15 % e <= 0,35 %, de manganes >= 0,25 % e <= 0,45 %, de fosforo >= 0,025 % e de enxofre <= 0,025 %;1;KG
7096;73045919;Outros tubos de outras ligas de acos, sem costura, secao circular, diametro exterior inferior ou igual a 229 mm;1;KG
7097;73045990;Outros tubos de outras ligas de acos, sem costura, secao circular;1;KG
7098;73049011;Outros tubos e perfis ocos, de diametro exterior inferior ou igual a 229 mm, de aco inoxidavel;1;KG
7099;73049019;Outros tubos e perfis ocos, de ferro ou aco,  sem costura, de diametro exterior inferior ou igual a 229 mm;1;KG
7100;73049090;Outros tubos e perfis ocos, de ferro ou aco, sem costura;1;KG
7101;73051100;Tubos dos tipos utilizados em oleodutos ou gasodutos, soldados longitudinalmente por arco imerso, de secao circular, de diametro exterior superior a 406,4 mm, de ferro ou aco;1;KG
7102;73051200;Outros tubos dos tipos utilizados em oleodutos ou gasodutos, soldados longitudinalmente, de secao circular, de diametro exterior superior a 406,4 mm, de ferro ou aco;1;KG
7103;73051900;Outros tubos dos tipos utilizados em oleodutos ou gasodutos, de secao circular, de diametro exterior superior a 406,4 mm, de ferro ou aco;1;KG
7104;73052000;Tubos para revestimento de pocos, dos tipos utilizados na extracao de petroleo ou de gas, de secao circular, de diametro exterior superior a 406,4 mm, de ferro ou aco;1;KG
7105;73053100;Outros tubos ferro ou aco, soldado longitudinalmente, de secao circular, de diametro exterior superior a 406,4 mm;1;KG
7106;73053900;Outros tubos ferro ou aco, soldado, de secao circular, de diametro exterior superior a 406,4 mm;1;KG
7107;73059000;Outros tubos de ferro ou aco, rebitados, de secao circular, de diametro exterior superior a 406,4 mm;1;KG
7108;73061100;Tubos dos tipos utilizados em oleodutos ou gasodutos, soldados, de aco inoxidavel;1;KG
7109;73061900;Outros tubos dos tipos utilizados em oleodutos ou gasodutos;1;KG
7110;73062100;Tubos para revestimento de pocos, de producao ou suprimento, dos tipos utilizados na extracao de petroleo ou de gas, soldados, de aco inoxidavel;1;KG
7111;73062900;Outros tubos para revestimento de pocos, de producao ou suprimento, dos tipos utilizados na extracao de petroleo ou de gas, de ferro ou aco;1;KG
7112;73063000;Outros tubos soldados, de secao circular, de ferro ou aco nao ligado;1;KG
7113;73064000;Outros tubos soldados, de secao circular, de aco inoxidavel;1;KG
7114;73065000;Outros tubos soldados, de secao circular, de outras ligas de aco;1;KG
7115;73066100;Outros tubos soldados, de secao quadrada ou retangular;1;KG
7116;73066900;Outros tubos soldados de secao nao circular;1;KG
7117;73069010;Outros tubos e perfis ocos, de ferro ou aco nao ligado;1;KG
7118;73069020;Outros tubos e perfis ocos, de aco inoxidavel;1;KG
7119;73069090;Outros tubos e perfis ocos, de ferro ou aco, soldados, rebitados, agrafados ou com os bordos simplesmente aproximados;1;KG
7120;73071100;Acessorios moldados para tubos de ferro fundido nao maleavel;1;KG
7121;73071910;Acessorios moldados para tubos de ferro fundido maleavel, de diametro interior superior a 50,8 mm;1;KG
7122;73071920;Acessorios moldados para tubos de aco;1;KG
7123;73071990;Outros acessorios para tubos moldados de ferro fundido, etc;1;KG
7124;73072100;Flanges para tubos, de acos inoxidaveis;1;KG
7125;73072200;Cotovelos, curvas e luvas, roscados, para tubos, de aco inoxidavel;1;KG
7126;73072300;Acessorios para soldar topo a topo, para tubos de acos inoxidavel;1;KG
7127;73072900;Outros acessorios para tubos, de acos inoxidaveis;1;KG
7128;73079100;Outras flanges para tubos, de ferro fundido/ferro ou aco;1;KG
7129;73079200;Outros cotovelos, curvas e luvas, roscados, para tubos de ferro/aco;1;KG
7130;73079300;Outros acessorios para soldar topo a topo, tubos de ferro/aco;1;KG
7131;73079900;Outros acessorios para tubos de ferro fundido, ferro ou aco;1;KG
7132;73081000;Pontes e elementos de pontes, de ferro fundido/ferro/aco;1;KG
7133;73082000;Torres e porticos, de ferro fundido, ferro ou aco;1;KG
7134;73083000;Portas e janelas, e seus caixilhos, alizares e soleiras, de ferro fundido, ferro ou aco;1;KG
7135;73084000;Material para andaimes, para armacoes ou para escoramentos, de ferro fundido, ferro ou aco;1;KG
7136;73089010;Chapas, barras, perfis, tubos e semelhantes, proprios para construcoes, de ferro fundido, ferro ou aco;1;KG
7137;73089090;Outras construcoes e suas partes, de ferro fundido/ferro/aco;1;KG
7138;73090010;Reservatorios, etc, de ferro/aco, de capacidade superior a 300 litros, para armazenamento de graos e outras materias solidas;1;KG
7139;73090020;Recipientes isotermicos refrigerados a nitrogenio (azoto) liquido, dos tipos utilizados para semen, sangue, tecidos biologicos e outros produtos similares, de capacidade superior a 300 litros;1;KG
7140;73090090;Outros reservatorios, etc, de ferro/aco, capacidade > 300 litros, sem dispersao termica;1;KG
7141;73101010;Recipientes isotermicos refrigerados a nitrogenio (azoto) liquido, dos tipos utilizados para semen, sangue, tecidos biologicos e outros produtos similares, de capacidade igual ou superior a 50 litros e menor que 300 litros;1;KG
7142;73101090;Outros reservatorios, etc, de ferro/aco, capacidade de 50 ate 300 litros, sem dispersao termica;1;KG
7143;73102110;Latas proprias para serem fechadas por soldadura ou cravacao, proprias para acondicionar produtos alimenticios, de ferro fundido, ferro ou aco;1;KG
7144;73102190;Outras latas proprias para serem fechadas por soldadura ou cravacao, de ferro fundido, ferro ou aco;1;KG
7145;73102910;Outros reservatorios, etc, de ferro/aco, capacidade < 50 litros, proprios para acondicionar produtos alimenticios;1;KG
7146;73102920;Recipientes isotermicos refrigerados a nitrogenio (azoto) liquido, dos tipos utilizados para semen, sangue, tecidos biologicos e outros produtos similares, capacidade menor que 50 litros;1;KG
7147;73102990;Outros reservatorios, etc, de ferro/aco, capacidade menor que 50 litros;1;KG
7148;73110000;Recipientes para gases comprimidos ou liquefeitos, de ferro fundido, ferro ou aco;1;KG
7149;73121010;Cordas e cabos, de fios de aco revestidos de bronze ou latao, nao isolados para usos eletricos;1;KG
7150;73121090;Outras cordas e cabos, de ferro ou aco, nao isolados para usos eletricos;1;KG
7151;73129000;Trancas, lingas e artefatos semelhantes, de ferro ou aco, nao isolados para usos eletricos;1;KG
7152;73130000;Arame farpado, de ferro ou aco, arames ou tiras, retorcidos, mesmo farpados, de ferro ou aco, dos tipos utilizados em cercas;1;KG
7153;73141200;Telas metalicas, continuas ou sem fim, para maquinas, de aco inoxidavel, tecidas;1;KG
7154;73141400;Outras telas metalicas tecidas, de aco inoxidavel;1;KG
7155;73141900;Outras telas metalicas tecidas, de ferro ou aco;1;KG
7156;73142000;Grades e redes, soldadas nos pontos de intersecao, de fios de ferro ou aco com, pelo menos, 3 mm na maior dimensao do corte transversal e com malhas de 100 cm2 ou mais, de superficie;1;KG
7157;73143100;Outras grades e redes, soldadas nos pontos de intersecao,  de fios de ferro ou aco, galvanizadas;1;KG
7158;73143900;Outras grades e redes, soldadas nos pontos de intersecao,  de fios de ferro ou aco;1;KG
7159;73144100;Outras telas metalicas, grades e redes, de fios de ferro ou aco, galvanizadas;1;KG
7160;73144200;Outras telas metalicas, grades e redes, de fios de ferro ou aco, revestidas de plasticos;1;KG
7161;73144900;Outras telas metalicas, grades e redes, de fios de ferro ou aco;1;KG
7162;73145000;Chapas e tiras, distendidas, de ferro ou aco;1;KG
7163;73151100;Corrente de rolos, de ferro fundido, de ferro ou aco;1;KG
7164;73151210;Corrente de transmissao, de ferro fundido, de ferro ou aco;1;KG
7165;73151290;Outras correntes de elos articulados, de ferro ou aco;1;KG
7166;73151900;Partes de correntes de elos articulados, de ferro ou aco;1;KG
7167;73152000;Correntes antiderrapantes, de ferro fundido, ferro ou aco;1;KG
7168;73158100;Correntes de elos com suporte, de ferro fundido, ferro ou aco;1;KG
7169;73158200;Outras correntes de elos soldados, de ferro fundido, ferro ou aco;1;KG
7170;73158900;Outras correntes e cadeias, de ferro fundido, ferro ou aco;1;KG
7171;73159000;Partes de outras correntes e cadeias, de ferro ou aco;1;KG
7172;73160000;Ancoras, fateixas, e suas partes, de ferro fundido, ferro ou aco;1;KG
7173;73170010;Tachas, mesmo com a cabeca de outra materia, exceto cobre, de ferro fundido, ferro ou aco;1;KG
7174;73170020;Grampos de fio curvado, de ferro fundido, ferro ou aco;1;KG
7175;73170030;Pontas ou dentes para maquinas texteis, de ferro fundido, ferro ou aco;1;KG
7176;73170090;Pregos, percevejos e artefatos semelhantes, de ferro fundido, ferro ou aco;1;KG
7177;73181100;Tira-fundos (roscados), de ferro fundido, ferro ou aco;1;KG
7178;73181200;Outros parafusos de ferro fundido/ferro/aco, para madeira;1;KG
7179;73181300;Ganchos e armelas, de ferro fundido, ferro ou aco;1;KG
7180;73181400;Parafusos perfurantes, de ferro fundido, ferro ou aco;1;KG
7181;73181500;Outros parafusos e pinos ou pernos, mesmo com as porcas e arruelas, de ferro fundido, ferro ou aco;1;KG
7182;73181600;Porcas de ferro fundido, ferro ou aco;1;KG
7183;73181900;Outros artefatos roscados, de ferro fundido, ferro ou aco;1;KG
7184;73182100;Arruelas de pressao e outras arruelas de seguranca, de ferro fundido, ferro ou aco;1;KG
7185;73182200;Outras arruelas de ferro fundido, ferro ou aco;1;KG
7186;73182300;Rebites de ferro fundido, ferro ou aco;1;KG
7187;73182400;Chavetas, cavilhas e contrapinos ou trocos, de ferro fundido, ferro ou aco;1;KG
7188;73182900;Outros artefatos nao roscados, de ferro fundido, ferro ou aco;1;KG
7189;73194000;Alfinetes de seguranca e outros alfinetes;1;KG
7190;73199000;Outras agulhas/artefatos semelhantes, de uso manual, de ferro/aco;1;KG
7191;73201000;Molas de folhas e suas folhas, de ferro ou aco;1;KG
7192;73202010;Molas helicoidais cilindricas, de ferro ou aco;1;KG
7193;73202090;Outras molas helicoidais de ferro ou aco;1;KG
7194;73209000;Outras molas de ferro ou aco;1;KG
7195;73211100;Aparelhos para cozinhar e aquecedores de pratos, de ferro fundido, ferro ou aco, a combustiveis gasosos, ou a gas e outros combustiveis;1;UN
7196;73211200;Aparelhos para cozinhar e aquecedores de pratos, de ferro fundido, ferro ou aco, a combustiveis liquidos;1;UN
7197;73211900;Outros aparelhos para cozinhar e aquecedores de pratos, incluindo os aparelhos a combustiveis solidos;1;UN
7198;73218100;Outros aquecedores, etc, de ferro/aco, a combustiveis gasosos, ou a gas e outros combustiveis;1;UN
7199;73218200;Outros aquecedores, etc, de ferro/aco, a combustiveis liquidos;1;UN
7200;73218900;Outros aparelhos, incluindo os aparelhos a combustiveis solidos;1;UN
7201;73219000;Partes de aparelhos para cozinhar, etc, de ferro/aco, nao eletrico;1;KG
7202;73221100;Radiadores para aquecimento central, nao eletrico, partes, de ferro fundido;1;KG
7203;73221900;Radiadores para aquecimento central, nao eletrico, partes, de ferro/aco;1;KG
7204;73229010;Geradores de ar quente a combustivel liquido, utilizados em veiculos automoveis;1;KG
7205;73229090;Outros geradores, etc. nao eletrico, de ferro fundido, ferro, aco;1;KG
7206;73231000;Palha de ferro ou aco, esponjas, esfregoes, luvas e artefatos semelhantes para limpeza, polimento ou usos semelhantes;1;KG
7207;73239100;Outros artefatos domesticos, de ferro fundido, nao esmaltados, e partes;1;KG
7208;73239200;Outros artefatos domesticos, de ferro fundido, esmaltados, e partes;1;KG
7209;73239300;Outros artefatos domesticos, de acos inoxidaveis, e partes;1;KG
7210;73239400;Outros artefatos domesticos, de ferro ou aco, esmaltados, e partes;1;KG
7211;73239900;Outros artefatos domesticos, de ferro fundido, ferro ou aco, e partes;1;KG
7212;73241000;Pias e lavatorios, de acos inoxidaveis;1;KG
7213;73242100;Banheiras de ferro fundido, mesmo esmaltadas;1;KG
7214;73242900;Outras banheiras de ferro ou aco;1;KG
7215;73249000;Outros artefatos de higiene e toucador, de ferro ou aco,  incluindo as partes;1;KG
7216;73251000;Outras obras moldadas de ferro fundido, nao maleavel;1;KG
7217;73259100;Esferas e artefatos semelhantes, para moinhos, moldadas, de ferro fundido, ferro ou aco;1;KG
7218;73259910;Outras obras moldadas, de aco;1;KG
7219;73259990;Outras obras moldadas, de ferro fundido ou ferro;1;KG
7220;73261100;Esferas e artefatos semelhantes, para moinhos, simplesmente forjadas ou estampadas, de ferro ou aco;1;KG
7221;73261900;Outras obras simplesmente forjadas ou estampadas, de ferro ou aco;1;KG
7222;73262000;Obras de fios de ferro ou aco;1;KG
7223;73269010;Calotas elipticas de aco ao niquel utilizadas na fabricacao de recipientes;1;KG
7224;73269090;Outras obras de ferro ou aco;1;KG
7225;74010000;Mates de cobre, cobre de cementacao (precipitado de cobre);1;KG
7226;74020000;Cobre nao refinado, anodos de cobre para refinacao eletrolitica;1;KG
7227;74031100;Catodos e seus elementos de cobre refinado, em formas brutas;1;TON
7228;74031200;Barras para obtencao de fios (wire-bars), de cobre refinado, em formas brutas;1;TON
7229;74031300;Palanquilhas (billets) de cobre refinado, em formas brutas;1;TON
7230;74031900;Outros produtos de cobre refinado, em formas brutas;1;TON
7231;74032100;Ligas de cobre a base de cobre-zinco (latao), em formas brutas;1;KG
7232;74032200;Ligas de cobre a base de cobre-estanho (bronze), em formas brutas;1;KG
7233;74032900;Outras ligas de cobre (exceto ligas-mae da posicao 74.05), em formas brutas;1;KG
7234;74040000;Desperdicios e residuos, de cobre;1;KG
7235;74050000;Ligas-maes de cobre;1;KG
7236;74061000;Pos de cobre, de estrutura nao lamelar;1;KG
7237;74062000;Pos de estrutura lamelar, escamas, de cobre;1;KG
7238;74071010;Barras de cobre refinado;1;KG
7239;74071021;Perfis ocos de cobre refinado;1;KG
7240;74071029;Outros perfis de cobre refinado;1;KG
7241;74072110;Barras de ligas a base de cobre-zinco (latao);1;KG
7242;74072120;Perfis de ligas  a base de cobre-zinco (latao);1;KG
7243;74072910;Outras barras de cobre;1;KG
7244;74072921;Outros perfis ocos de cobre;1;KG
7245;74072929;Outros perfis de cobre;1;KG
7246;74081100;Fios de cobre refinado, com a maior dimensao da secao transversal superior a 6 mm;1;KG
7247;74081900;Outros fios de cobre refinado;1;KG
7248;74082100;Fios de ligas a base de cobre-zinco (latao);1;KG
7249;74082200;Fios de ligas a base de cobre-niquel (cuproniquel) ou de cobre-niquel-zinco (maillechort);1;KG
7250;74082911;Fios de ligas de cobre-estanho (bronze) fosforoso;1;KG
7251;74082919;Outros fios de ligas de cobre-estanho (bronze);1;KG
7252;74082990;Outros fios de ligas de cobre;1;KG
7253;74091100;Chapas e tiras, de cobre refinado, de espessura superior a 0,15 mm, em rolos;1;KG
7254;74091900;Outras chapas e tiras, de cobre refinado,de espessura superior a 0,15 mm;1;KG
7255;74092100;Chapas e tiras de ligas a base de cobre-zinco (latao, de espessura superior a 0,15 mm, em rolos;1;KG
7256;74092900;Outras chapas e tiras, de ligas a base de cobre-zinco (latao), de espessura superior a 0,15 mm;1;KG
7257;74093111;Chapas de ligas a base de cobre-estanho (bronze), de espessura superior a 0,15 mm, revestidas de plastico, com uma camada intermediaria de liga de cobre-estanho ou cobre-estanho-chumbo, aplicada por sinterizacao;1;KG
7258;74093119;Outras chapas de ligas a base de cobre-estanho (bronze), de espessura superior a 0,15 mm, em rolos, revestidas de plastico;1;KG
7259;74093190;Outras chapas de ligas a base de cobre-estanho (bronze), de espessura superior a 0,15 mm, em rolos;1;KG
7260;74093900;Outras chapas e tiras, de ligas  a base de cobre-estanho (bronze), de espessura superior a 0,15 mm;1;KG
7261;74094010;Chapas e tiras de ligas a base de cobre-niquel (cuproniquel) ou de cobre-niquel-zinco (maillechort), de espessura superior a 0,15 mm, em rolos;1;KG
7262;74094090;Outras chapas e tiras de ligas a base de cobre-niquel (cuproniquel) ou de cobre-niquel-zinco (maillechort), de espessura superior a 0,15 mm;1;KG
7263;74099000;Chapas e tiras, de outras ligas de cobre, de espessura superior a 0,15 mm;1;KG
7264;74101112;Folha de cobre, de espessura inferior ou igual a 0,04 mm e uma resistividade eletrica inferior ou igual a 0,017241 ohm.mm2/m;1;KG
7265;74101113;Outras folhas de cobre, de espessura inferior ou igual a 0,04 mm;1;KG
7266;74101119;Folha de cobre refinado sem suporte, espessura > 0,04 mm e < 0,07 mm, pureza > 99,85=%;1;KG
7267;74101190;Outras folhas/tiras, de cobre refinado, sem suporte, espessura <= 0.15 mm;1;KG
7268;74101200;Folha e tira, de ligas de cobre, sem suporte, espessura <= 0.15 mm;1;KG
7269;74102110;Folha de cobre refinado, com suporte isolante de resina epoxida e fibra de vidro, dos tipos utilizados para circuitos impressos;1;KG
7270;74102120;Folha de cobre refinado, com espessura superior a 0,012 mm, sobre suporte de poliester ou poliimida e com espessura total, incluindo o suporte, inferior ou igual a 0,195 mm;1;KG
7271;74102130;Folha de cobre, om suporte isolante de resina fenolica e papel, dos tipos utilizados para circuitos impressos;1;KG
7272;74102190;Outras folhas/tiras, de cobre refinado com suporte, espessura <= 0.15 mm;1;KG
7273;74102200;Folha e tira, de ligas de cobre, com suporte, espessura <= 0.15mm;1;KG
7274;74111010;Tubos de cobre refinado, nao aletados nem ranhurados;1;KG
7275;74111090;Outros tubos de cobre refinado;1;KG
7276;74112110;Tubos de ligas de cobre-zinco, nao aletados, nao ranhurados;1;KG
7277;74112190;Outros tubos de ligas de cobre-zinco;1;KG
7278;74112210;Tubos de ligas a base de cobre-niquel (cuproniquel) ou de cobre-niquel-zinco (maillechort), nao aletados nao ranhurados;1;KG
7279;74112290;Outros tubos de ligas de cobre-niquel/cobre-niquel-zinco;1;KG
7280;74112910;Tubos de outras ligas de cobre, nao aletados nao ranhurados;1;KG
7281;74112990;Tubos de outras ligas de cobre;1;KG
7282;74121000;Acessorios para tubos (por exemplo, unioes, cotovelos, luvas), de cobre refinado;1;KG
7283;74122000;Acessorios para tubos (por exemplo, unioes, cotovelos, luvas), de ligas de cobre;1;KG
7284;74130000;Cordas, cabos, trancas e artefatos semelhantes, de cobre, nao isolados para usos eletricos;1;KG
7285;74151000;Tachas, pregos, percevejos, escapulas e artefatos semelhantes, de cobre ou de ferro ou aco com cabeca de cobre;1;KG
7286;74152100;Arruelas (incluindo as de pressao), de cobre;1;KG
7287;74152900;Outros artefatos nao roscados, de cobre;1;KG
7288;74153300;Parafusos, pinos ou pernos e porcas, de cobre;1;KG
7289;74153900;Outros artefatos roscados, de cobre;1;KG
7290;74181000;Artefatos de uso domestico e suas partes, esponjas, esfregoes, luvas e artefatos semelhantes, para limpeza, polimento ou usos semelhantes;1;KG
7291;74182000;Artefatos de higiene ou de toucador, e suas partes, de cobre;1;KG
7292;74191000;Correntes, cadeias, e suas partes, de cobre;1;KG
7293;74199100;Outras obras de cobre, vazadas, moldadas, estampadas ou forjadas, mas nao trabalhadas de outro modo;1;KG
7294;74199910;Telas metalicas de fios de cobre;1;KG
7295;74199920;Grades e redes, de fio de cobre, chapas e tiras, distendidas;1;KG
7296;74199930;Molas de cobre;1;KG
7297;74199990;Aparelhos para cozinhar/aquecer, de cobre, nao eletrico, uso domestico;1;KG
7298;75011000;Mates de niquel;1;KG
7299;75012000;Sinters de oxidos de niquel e outros produtos intermediarios da metalurgia do niquel;1;KG
7300;75021010;Catodos de niquel nao ligado, em formas brutas;1;TON
7301;75021090;Outro niquel nao ligado, em formas brutas;1;TON
7302;75022000;Ligas de niquel, em forma bruta;1;KG
7303;75030000;Desperdicios e residuos, de niquel;1;KG
7304;75040010;Pos e escamas, de niquel nao ligado;1;KG
7305;75040090;Outros pos e escamas, de niquel;1;KG
7306;75051110;Barras de niquel nao ligado;1;KG
7307;75051121;Perfis ocos de niquel nao ligado;1;KG
7308;75051129;Outros perfis de niquel nao ligado;1;KG
7309;75051210;Barras de ligas de niquel;1;KG
7310;75051221;Perfis ocos de ligas de niquel;1;KG
7311;75051229;Outros perfis de ligas de niquel;1;KG
7312;75052100;Fios de niquel nao ligado;1;KG
7313;75052200;Fios de ligas de niquel;1;KG
7314;75061000;Chapas, tiras e folhas, de niquel nao ligado;1;KG
7315;75062000;Chapas, tiras e folhas, de ligas de niquel;1;KG
7316;75071100;Tubos de niquel nao ligado;1;KG
7317;75071200;Tubos de ligas de niquel;1;KG
7318;75072000;Acessorios para tubos de niquel (por exemplo, unioes, cotovelos, luvas);1;KG
7319;75081000;Telas metalicas e grades, de fios de niquel;1;KG
7320;75089010;Cilindros ocos de secao variavel, obtidos por centrifugacao, dos tipos utilizados em reformadores estequiometricos de gas natural;1;KG
7321;75089090;Outras obras de niquel;1;KG
7322;76011000;Aluminio nao ligado, em formas brutas;1;TON
7323;76012000;Ligas de aluminio, em formas brutas;1;KG
7324;76020000;Desperdicios e residuos, de aluminio;1;KG
7325;76031000;Pos de aluminio, de estrutura nao lamelar;1;KG
7326;76032000;Pos de estrutura lamelar, escamas, de aluminio;1;KG
7327;76041010;Barras de aluminio nao ligado;1;KG
7328;76041021;Perfis ocos de aluminio nao ligado;1;KG
7329;76041029;Outros perfis de aluminio nao ligado;1;KG
7330;76042100;Perfis ocos de ligas de aluminio;1;KG
7331;76042911;Barras de liga aluminio, forjadas, de secao transversal circular, de diametro superior ou igual a 400 mm mas inferior ou igual a 760 mm;1;KG
7332;76042919;Outras barras de ligas de aluminio;1;KG
7333;76042920;Outros perfis de ligas de aluminio;1;KG
7334;76051110;Fios de aluminio nao ligado, com a maior dimensao da secao transversal superior a 7 mm, com um teor de aluminio superior ou igual a 99,45 %, em peso, e uma resistividade eletrica inferior ou igual a 0,0283 ohm.mm2/m;1;KG
7335;76051190;Outros fios de aluminio nao ligado, com a maior dimensao da secao transversal superior a 7 mm;1;KG
7336;76051910;Outros fios de aluminio nao ligado, com um teor de aluminio superior ou igual a 99,45 %, em peso, e uma resistividade eletrica inferior ou igual a 0,0283 ohm.mm2/m;1;KG
7337;76051990;Outros fios de aluminio, nao ligados;1;KG
7338;76052110;Fios de liga de aluminio, com a maior dimensao da secao transversal > 7 mm, com um teor, em peso, de aluminio >=  98,45 %, e de magnesio e silicio, considerados individualmente, >= 0,45 % e <= 0,55 % e uma resistividade eletrica <= 0,0328 ohm.mm2/m;1;KG
7339;76052190;Outros fios de ligas de aluminio, com a maior dimensao da secao transversal superior a 7 mm;1;KG
7340;76052910;Outros fios de liga de aluminio, resistencia <= 0.0328 ohm.mm2;1;KG
7341;76052990;Outros fios de ligas aluminio;1;KG
7342;76061110;Chapas de aluminio nao ligado, espessura > 0.2 mm, quadrada teor silicio, etc;1;KG
7343;76061190;Outras chapas/tiras de aluminio nao ligado, espessura > 0.2. mm, quadrada/retangular;1;KG
7344;76061210;Chapas de ligas aluminio, 0.2 mm < espessura <= 0.3mm, largura >= 1450 mm, envernizadas;1;KG
7345;76061220;Outras chapas de aluminio nao ligado, espessura > 0.2 mm, de forma quadrada ou retangular, etc;1;KG
7346;76061290;Outras chapas e tiras, de ligas aluminio, espessura > 0.2mm;1;KG
7347;76069100;Outras chapas e tiras, de aluminio nao ligado, espessura > 0.2mm;1;KG
7348;76069200;Outras chapas e tiras, de ligas de aluminio, espessura > 0.2mm;1;KG
7349;76071110;Folhas de aluminio sem suporte, simplesmente laminado, espessura <= 0.2 mm, etc;1;KG
7350;76071190;Outras folhas e tiras, de aluminio sem suporte, laminado, espessura <= 0.2 mm;1;KG
7351;76071910;Folhas e tiras, de aluminio, sem suporte, gravadas, mesmo com camada de oxido de aluminio, de espessura inferior ou igual a 110 micrometros (microns) e com um conteudo de aluminio superior ou igual a 99,9 %, em peso;1;KG
7352;76071990;Outras folhas e tiras, de aluminio, sem suporte, espessura <= 0.2mm;1;KG
7353;76072000;Folhas e tiras, delgadas, de aluminio (mesmo impressas ou com suporte de papel, cartao, plasticos ou semelhantes), de espessura nao superior a 0,2 mm, com suporte;1;KG
7354;76081000;Tubos de aluminio nao ligado;1;KG
7355;76082010;Tubos de ligas de aluminio, sem costura, extrudados e trefilados, segundo Norma ASTM B210, de secao circular, de liga AA 6061 (Aluminium Association), com limite elastico aparente de Johnson (JAEL) > 3.000 Nm, segundo Norma SAE AE7, diametro externo >= 85;1;KG
7356;76082090;Outros tubos de ligas de aluminio;1;KG
7357;76090000;Acessorios para tubos (por exemplo, unioes, cotovelos, luvas), de aluminio;1;KG
7358;76101000;Portas e janelas, e seus caixilhos, alizares e soleiras, de aluminio;1;KG
7359;76109000;Construcoes e suas partes, chapas, barras, etc, de aluminio;1;KG
7360;76110000;Reservatorios, toneis, cubas e recipientes semelhantes para quaisquer materias (exceto gases comprimidos ou liquefeitos), de aluminio, de capacidade superior a 300 l, sem dispositivos mecanicos ou termicos, mesmo com revestimento interior ou calorifugo.;1;KG
7361;76121000;Recipientes tubulares, flexiveis, de aluminio, de capacidade nao superior a 300 litros, sem dispositivo mecanico;1;KG
7362;76129011;Recipientes tubulares de aluminio, para aerossois, com capacidade inferior ou igual a 700 cm3;1;KG
7363;76129012;Recipientes tubulares, de aluminio, isotermicos, refrigerados a nitrogenio (azoto) liquido, dos tipos utilizados para semen, sangue, tecidos biologicos e outros produtos similares;1;KG
7364;76129019;Outros recipientes tubulares, de aluminio, de capacidade nao superior a 300 litros;1;KG
7365;76129090;Outros reservatorios, etc, de aluminio, de capacidade nao superior a 300 litros, sem dispositivo mecanico/termal;1;KG
7366;76130000;Recipientes para gases comprimidos ou liquefeitos, de aluminio;1;KG
7367;76141010;Cordas e cabos, de aluminio, com alma de aco, nao isolados para usos eletricos;1;KG
7368;76141090;Trancas, etc, de aluminio, com alma de aco, nao isolados para usos eletricos;1;KG
7369;76149010;Outros cabos de aluminio, nao isolados para usos eletricos;1;KG
7370;76149090;Outras cordas, trancas, etc, nao isolados para usos eletricos;1;KG
7371;76151000;Artefatos de uso domestico e suas partes, esponjas, esfregoes, luvas e artefatos semelhantes, para limpeza, polimento ou usos semelhantes, de aluminio;1;KG
7372;76152000;Artefatos de higiene ou de toucador, e suas partes, de aluminio;1;KG
7373;76161000;Tachas, pregos, escapulas, parafusos, pinos ou pernos roscados, porcas, ganchos roscados, rebites, chavetas, cavilhas, contrapinos ou trocos, arruelas e artefatos semelhantes, de aluminio;1;KG
7374;76169100;Telas metalicas, grades e redes, de fios de aluminio;1;KG
7375;76169900;Outras obras de aluminio;1;KG
7376;78011011;Chumbo refinado, eletrolitico, em lingotes;1;TON
7377;78011019;Outras formas brutas de chumbo refinado, eletrolitico;1;TON
7378;78011090;Outras formas brutas de chumbo refinado;1;TON
7379;78019100;Chumbos que contenham antimonio como segundo elemento predominante em peso;1;TON
7380;78019900;Outras formas brutas de chumbo;1;TON
7381;78020000;Desperdicios e residuos, de chumbo;1;KG
7382;78041100;Folhas e tiras, de chumbo, de espessura nao superior a 0,2 mm (excluindo o suporte);1;KG
7383;78041900;Chapas e outras folhas e tiras, de chumbo;1;KG
7384;78042000;Pos e escamas de chumbo;1;KG
7385;78060010;Barras, perfis e fios de chumbo;1;KG
7386;78060020;Tubos e acessorios (unioes, luvas, etc) chumbo;1;KG
7387;78060090;Outras obras de chumbo;1;KG
7388;79011111;Zinco nao ligado, que contenha, em peso, 99,99 % ou mais de zinco, eletrolitico, em lingotes;1;TON
7389;79011119;Outras zincos nao ligados, que contenha, em peso, 99,99 % ou mais de zinco, eletrolitico;1;TON
7390;79011191;Outros lingotes de zinco nao ligados, que contenham, em peso, 99,99 % ou mais de zinco;1;TON
7391;79011199;Outras formas brutas de zinco nao ligado, que contenha, em peso, 99,99 % ou mais de zinco;1;TON
7392;79011210;Zinco nao ligado, que contenha, em peso, menos de 99,99 % de zinco, em lingotes;1;TON
7393;79011290;Zinco nao ligado, que contenha, em peso, menos de 99,99 % de zinco, em outras formas;1;TON
7394;79012010;Ligas de zinco, em lingotes;1;TON
7395;79012090;Outras ligas de zinco;1;TON
7396;79020000;Desperdicios e residuos, de zinco;1;KG
7397;79031000;Poeiras de zinco;1;KG
7398;79039000;Pos e escamas, de zinco;1;KG
7399;79040000;Barras, perfis e fios, de zinco;1;KG
7400;79050000;Chapas, folhas e tiras, de zinco;1;KG
7401;79070010;Tubos e seus acessorios, de zinco;1;KG
7402;79070090;Outras obras de zinco;1;KG
7403;80011000;Estanho nao ligado, em forma bruta;1;TON
7404;80012000;Ligas de estanho, em forma bruta;1;KG
7405;80020000;Desperdicios e residuos, de estanho;1;KG
7406;80030000;Barras, perfis e fios, de estanho;1;KG
7407;80070010;Chapas, folhas e tiras, de estanho;1;KG
7408;80070020;Pos e escamas, de estanho;1;KG
7409;80070030;Tubos e seus acessorios, de estanho;1;KG
7410;80070090;Outras obras de estanho;1;KG
7411;81011000;Pos de tungstenio (volframio);1;KG
7412;81019400;Tungstenio (volframio) em formas brutas, incluindo as barras simplesmente obtidas por sinterizacao;1;KG
7413;81019600;Fios de tungstenio;1;KG
7414;81019700;Desperdicios e residuos de tungstenio;1;KG
7415;81019910;Obras de tungstenio, do tipo dos utilizados na fabricacao de contatos eletricos;1;KG
7416;81019990;Outras obras de tungstenio;1;KG
7417;81021000;Pos de molibdenio;1;KG
7418;81029400;Molibdenio em formas brutas, incluindo as barras simplesmente obtidas por sinterizacao;1;KG
7419;81029500;Barras de molibdenio, exceto as simplesmente obtidas por sinterizacao, perfis, chapas, tiras e folhas;1;KG
7420;81029600;Fios de molibdenio;1;KG
7421;81029700;Desperdicios e residuos de molibdenio;1;KG
7422;81029900;Outras obras de molibdenio;1;KG
7423;81032000;Tantalo em formas brutas, incluindo as barras simplesmente obtidas por sinterizacao, pos;1;KG
7424;81033000;Desperdicios e residuos de tantalo;1;KG
7425;81039000;Outras obras de tantalo;1;KG
7426;81041100;Magnesio em formas brutas, que contenha pelo menos 99,8 %, em peso, de magnesio;1;KG
7427;81041900;Outras formas brutas de magnesio;1;KG
7428;81042000;Desperdicios e residuos, de magnesio;1;KG
7429;81043000;Aparas, residuos de torno e granulos, calibrados, pos, de magnesio;1;KG
7430;81049000;Outras obras de magnesio;1;KG
7431;81052010;Cobalto em formas brutas;1;KG
7432;81052021;Pos de ligas a base de cobalto-cromo-tungstenio (volframio) (estelites);1;KG
7433;81052029;Outros pos;1;KG
7434;81052090;Mates de cobalto e outros produtos intermediarios metalicos;1;KG
7435;81053000;Desperdicios e residuos da metalurgia do cobalto;1;KG
7436;81059010;Chapas, folhas, tiras, fios, hastes, pastilhas e plaquetas, de cobalto;1;KG
7437;81059090;Outras obras de cobalto;1;KG
7438;81060010;Bismuto em bruto;1;KG
7439;81060090;Obras de bismuto, desperdicios e residuos, de bismuto;1;KG
7440;81072010;Cadmio em formas brutas;1;KG
7441;81072020;Cadmio em pos;1;KG
7442;81073000;Desperdicios e residuos do cadmio;1;KG
7443;81079000;Obras de cadmio;1;KG
7444;81082000;Titanio em formas brutas, e titanio em pos;1;KG
7445;81083000;Desperdicios e residuos do titanio;1;KG
7446;81089000;Obras de titanio;1;KG
7447;81092000;Zirconio em formas brutas, pos;1;KG
7448;81093000;Desperdicios e residuos do zirconio;1;KG
7449;81099000;Obras de zirconio;1;KG
7450;81101010;Antimonio em formas brutas;1;KG
7451;81101020;Antimonio em pos;1;KG
7452;81102000;Desperdicios e residuos do antimonio;1;KG
7453;81109000;Obras e outros produtos do antimonio;1;KG
7454;81110010;Manganes em bruto;1;KG
7455;81110020;Chapas, folhas, tiras, fios, hastes, pastilhas e plaquetas, de manganes;1;KG
7456;81110090;Outras obras de manganes, desperdicios e residuos de manganes;1;KG
7457;81121200;Berilio em formas brutas, e berilio em pos;1;KG
7458;81121300;Desperdicios e residuos do berilio;1;KG
7459;81121900;Obras de berilio;1;KG
7460;81122110;Cromo em formas brutas;1;KG
7461;81122120;Cromo em pos;1;KG
7462;81122200;Desperdicios e residuos do cromo;1;KG
7463;81122900;Obras e outros produtos do cromo;1;KG
7464;81125100;Talio em formas brutas, e talio em pos;1;KG
7465;81125200;Desperdicios e residuos do talio;1;KG
7466;81125900;Obras e outros produtos do talio;1;KG
7467;81129200;Galio, niobio, etc, em formas brutas, desperdicios e residuos, pos;1;KG
7468;81129900;Obras de galio, hafnio, indio, niobio, renio e talio;1;KG
7469;81130010;Chapas, folhas, tiras, fios, hastes, pastilhas e plaquetas, de ceramais;1;KG
7470;81130090;Outras obras de ceramais, desperdicios e residuos de ceramais;1;KG
7471;82011000;Pas de metais comuns;1;KG
7472;82013000;Alvioes, picaretas, enxadas, sachos, ancinhos e raspadeiras, de metais comuns;1;KG
7473;82014000;Machados, podoes e ferramentas semelhantes com gume, de metais comuns;1;KG
7474;82015000;Tesouras de podar (incluindo as tesouras para aves) manipuladas com uma das maos, de metais comuns;1;KG
7475;82016000;Tesouras para sebes, tesouras de podar e ferramentas semelhantes, manipuladas com as duas maos, de metais comuns;1;KG
7476;82019000;Outras ferramentas manuais para agricultura, horticultura e silvicultura;1;KG
7477;82021000;Serras manuais, de metais comuns;1;KG
7478;82022000;Folhas de serras de fita, de metais comuns;1;KG
7479;82023100;Folhas de serras circulares (incluindo as fresas-serras), com parte operante de aco;1;KG
7480;82023900;Outras folhas de serras circulares (incluindo as fresas-serras), incluindo as partes;1;KG
7481;82024000;Correntes cortantes de serras, de metais comuns;1;KG
7482;82029100;Folhas de serras retilineas, para trabalhar metais;1;KG
7483;82029910;Folha de serras, retas, nao dentadas, para serrar pedras, de metais coumuns;1;KG
7484;82029990;Outras folhas de serras, de metais comuns;1;KG
7485;82031010;Limas e grosas, de metais comuns;1;KG
7486;82031090;Outras ferramentas manuais, de metais comuns, igual limas;1;KG
7487;82032010;Alicates (mesmo cortantes);1;KG
7488;82032090;Tenazes, pincas, ferramentas manuais semelhantes de metais comuns;1;KG
7489;82033000;Cisalhas para metais e ferramentas semelhantes, uso manual, de metais comuns;1;KG
7490;82034000;Corta-tubos, corta-pinos, saca-bocados e ferramentas semelhantes, de metais comuns;1;KG
7491;82041100;Chaves de porcas, manuais, de abertura fixa, de metais comuns;1;KG
7492;82041200;Chaves de porcas, manuais, de abertura variavel, de metais comuns;1;KG
7493;82042000;Chaves de caixa intercambiaveis, mesmo com cabos, de metais comuns;1;KG
7494;82051000;Ferramentas de furar ou de roscar, de metais comuns, manuais;1;KG
7495;82052000;Martelos e marretas, manuais, de metais comuns;1;KG
7496;82053000;Plainas, formoes, goivas e ferramentas cortantes semelhantes, para trabalhar madeira;1;KG
7497;82054000;Chaves de fenda, manuais, de metais comuns;1;KG
7498;82055100;Outras ferramentas manuais, de metais comuns, uso domestico;1;KG
7499;82055900;Outras ferramentas manuais, de metais comuns, uso domestico;1;KG
7500;82056000;Lampadas ou lamparinas, de soldar (macaricos) e semelhantes, de metais comuns;1;KG
7501;82057000;Tornos de apertar, sargentos e semelhantes, de metais comuns;1;KG
7502;82059000;Outros, incluindo os sortidos constituidos por artefatos incluidos em pelo menos duas das subposicoes da presente posicao;1;KG
7503;82060000;Ferramentas de pelo menos duas das posicoes 82.02 a 82.05, acondicionadas em sortidos para venda a retalho;1;KG
7504;82071300;Ferramentas de perfuracao ou de sondagem, de metais comuns, com parte operante de ceramais (cermets);1;KG
7505;82071900;Outras ferramentas de perfuracao ou de sondagem, de metais comuns, inclusive partes;1;KG
7506;82072000;Fieiras de estiramento ou de extrusao, para metais;1;KG
7507;82073000;Ferramentas de embutir, de estampar ou de puncionar;1;KG
7508;82074010;Ferramentas de roscar interiormente, de metais comuns;1;KG
7509;82074020;Ferramentas de roscar exteriormente, de metais comuns;1;KG
7510;82075011;Brocas helicoidais, com diametro inferior ou igual a 52 mm, de metais comuns, inclusive diamantada;1;KG
7511;82075019;Outras brocas de metais comuns, mesmo diamantadas;1;KG
7512;82075090;Outras ferramentas de furar, de metais comuns;1;KG
7513;82076000;Ferramentas de mandrilar ou de brochar, de metais comuns;1;KG
7514;82077010;Ferramentas de fresar de topo, de metais comuns;1;KG
7515;82077020;Ferramentas de fresar para cortar engrenagens, de metais comuns;1;KG
7516;82077090;Outras ferramentas de fresar, de metais comuns;1;KG
7517;82078000;Ferramentas de tornear, de metais comuns;1;KG
7518;82079000;Outras ferramentas intercambiaveis, de metais comuns;1;KG
7519;82081000;Facas e laminas cortantes, para maquinas ou para aparelhos mecanicos, para trabalhar metais;1;KG
7520;82082000;Facas e laminas cortantes, para maquinas ou para aparelhos mecanicos, para trabalhar madeira;1;KG
7521;82083000;Facas e laminas cortantes, para maquinas ou para aparelhos mecanicos, para aparelhos de cozinha ou para maquinas das industrias alimentares;1;KG
7522;82084000;Facas e laminas cortantes, para maquinas ou para aparelhos mecanicos, para maquinas de agricultura, horticultura ou silvicultura;1;KG
7523;82089000;Outras facas e laminas cortantes, para maquinas ou para aparelhos mecanicos;1;KG
7524;82090011;Plaquetas ou pastilhas, nao montadas, de ceramais (cermets), intercambiaveis;1;KG
7525;82090019;Outras plaquetas ou pastilhas, nao montadas, de ceramais (cermets);1;KG
7526;82090090;Outras pontas e objetos semelhantes para ferramentas, nao montados, de ceramais (cermets);1;KG
7527;82100010;Moinhos mecanicos de acionamento manual, pesando ate 10 kg, utilizados para preparar, acondicionar ou servir alimentos ou bebidas;1;KG
7528;82100090;Outros aparelhos mecanicos de acionamento manual, pesando ate 10 kg, utilizados para preparar, acondicionar ou servir alimentos ou bebidas;1;KG
7529;82111000;Sortido de facas (exceto as da posicao 82.08) de lamina cortante ou serrilhada, incluindo as podadeiras de lamina movel, e suas laminas;1;UN
7530;82119100;Facas de mesa, de lamina fixa, de metais comuns;1;UN
7531;82119210;Facas de lamina fixa, para cozinha e acougue, de metais comuns;1;UN
7532;82119220;Facas de lamina fixa, para caca, de metais comuns;1;UN
7533;82119290;Outras facas de lamina fixa, de metais comuns;1;UN
7534;82119310;Facas podadeiras e suas partes, de metais comuns;1;UN
7535;82119320;Canivetes com uma ou varias laminas ou outras pecas;1;UN
7536;82119390;Outras facas exceto de lamina fixa, de metais comuns;1;UN
7537;82119400;Laminas para facas, de metais comuns;1;KG
7538;82119500;Cabos de metais comuns para facas de metais comuns;1;KG
7539;82121010;Navalhas de barbear, de metais comuns;1;UN
7540;82121020;Aparelhos de barbear, nao eletricos;1;UN
7541;82122010;Laminas de barbear, de seguranca, de metais comuns;1;UN
7542;82122020;Esbocos de laminas, em tiras, de metais comuns;1;UN
7543;82129000;Outras partes de navalhas/aparelhos de barbear, de metais comuns;1;KG
7544;82130000;Tesouras e suas laminas, de metais comuns;1;KG
7545;82141000;Espatulas, abre-cartas, etc, e suas laminas, de metais comuns;1;KG
7546;82142000;Utensilios e sortidos de utensilios de manicuros ou de pedicuros (incluindo as limas para unhas);1;KG
7547;82149010;Maquinas de tosquiar e suas partes, de metais comuns;1;KG
7548;82149090;Outros artigos de cutelaria de metais comuns, e suas partes;1;KG
7549;82151000;Colheres, garfos, conchas, escumadeiras, pas para tortas, facas especiais para peixe ou para manteiga, pincas para acucar e artefatos semelhantes, sortidos que contenham pelo menos um objeto prateado, dourado ou platinado;1;KG
7550;82152000;Outros sortidos de colher, garfo, concha, etc, de metais comuns;1;KG
7551;82159100;Colher, garfo, concha, etc, de metais comuns, prateado/dourado/platinado;1;KG
7552;82159910;Colheres, garfos, conchas, escumadeiras, etc, de acos inoxidaveis;1;KG
7553;82159990;Outras colheres, garfos, conchas, etc, de metais comuns;1;KG
7554;83011000;Cadeados de metais comuns;1;KG
7555;83012000;Fechaduras dos tipos utilizados em veiculos automoveis, de metais comuns;1;KG
7556;83013000;Fechaduras dos tipos utilizados em moveis, de metais comuns;1;KG
7557;83014000;Outras fechaduras, ferrolhos, de metais comuns;1;KG
7558;83015000;Fechos e armacoes com fecho, com fechadura, de metais comuns;1;KG
7559;83016000;Partes de cadeados, fechaduras, etc, de metais comuns;1;KG
7560;83017000;Chaves de metais comuns, apresentadas isoladamente;1;KG
7561;83021000;Dobradicas de qualquer tipo (incluindo os gonzos e as charneiras), de metais comuns;1;KG
7562;83022000;Rodizios com armacao, de metais comuns;1;KG
7563;83023000;Outras guarnicoes, ferragens e artigos semelhantes, para veiculos automoveis, de metais comuns;1;KG
7564;83024100;Outras guarnicoes, ferragens e artigos semelhantes, para construcoes, de mteais comuns;1;KG
7565;83024200;Outras guarnicoes, ferragens e artigos semelhantes, para moveis, de mteais comuns;1;KG
7566;83024900;Outras guarnicoes, ferragens e artigos semelhantes, de metais comuns;1;KG
7567;83025000;Pateras, porta-chapeus, cabides e artigos semelhantes, de metais comuns;1;KG
7568;83026000;Fechos automaticos para portas, de metais comuns;1;KG
7569;83030000;Cofres-fortes, portas blindadas e compartimentos para casas-fortes, cofres e caixas de seguranca e artefatos semelhantes, de metais comuns;1;KG
7570;83040000;Classificadores, ficharios, caixas de classificacao, porta-copias, porta-canetas, porta-carimbos e artefatos semelhantes, de escritorio, de metais comuns, excluindo os moveis de escritorio da posicao 94.03;1;KG
7571;83051000;Ferragens para encadernacao de folhas moveis ou para classificadores, de metais comuns;1;KG
7572;83052000;Grampos apresentados em barretas, de metais comuns;1;KG
7573;83059000;Molas para papeis, outros objetos de escritorio, de metais comuns;1;KG
7574;83061000;Sinos, campainhas, gongos e artefatos semelhantes, de metais comuns, nao eletricos;1;KG
7575;83062100;Estatuetas/objetos de ornamentacao, de metais comuns, folheado, prateados, dourados ou platinados;1;KG
7576;83062900;Outras estatuetas/objetos de ornamentacao, de metais comuns;1;KG
7577;83063000;Molduras para fotografias, gravuras ou semelhantes, espelhos, de metais comuns;1;KG
7578;83071010;Tubos flexiveis de aco, dos tipos utilizados na explotacao submarina de petroleo ou gas, constituidos por camadas flexiveis de aco e camadas de plastico, de diametro interior superior a 254 mm;1;KG
7579;83071090;Outros tubos flexiveis de ferro ou aco;1;KG
7580;83079000;Tubos flexiveis de outros metais comuns;1;KG
7581;83081000;Grampos, colchetes e ilhoses, de metais comuns, para vestuario, etc;1;KG
7582;83082000;Rebites tubulares ou de haste fendida, de metais comuns;1;KG
7583;83089010;Fivelas de metais comuns;1;KG
7584;83089020;Contas e lantejoulas, de metais comuns;1;KG
7585;83089090;Outros fechos, etc, de metais comuns, para vestuario, calcados, etc.;1;KG
7586;83091000;Capsulas de coroa, de metais comuns, para embalagem;1;KG
7587;83099000;Rolhas, outras tampas e acessorios para embalagem, de metais comuns;1;KG
7588;83100000;Placas indicadoras, placas sinalizadoras, placas-enderecos e placas semelhantes, numeros, letras e sinais diversos, de metais comuns, exceto os da posicao 94.05.;1;KG
7589;83111000;Eletrodos revestidos exteriormente para soldar a arco, de metais comuns;1;KG
7590;83112000;Fios revestidos interiormente para soldar a arco, de metais comuns;1;KG
7591;83113000;Varetas revestidas exteriormente e fios revestidos interiormente, para soldar a chama, de metais comuns;1;KG
7592;83119000;Outros fios, varetas, tubos, chapas, etc, de metais comuns;1;KG
7593;84011000;Reatores nucleares;1;UN
7594;84012000;Maquinas e aparelhos para a separacao de isotopos, e suas partes;1;KG
7595;84013000;Elementos combustiveis (cartuchos) nao irradiados, para reatores nucleares;1;KG
7596;84014000;Partes de reatores nucleares;1;KG
7597;84021100;Caldeiras aquatubulares com producao de vapor superior a 45 t por hora;1;UN
7598;84021200;Caldeiras aquatubulares com producao de vapor nao superior a 45 t por hora;1;UN
7599;84021900;Outras caldeiras para producao de vapor, incluindo as caldeiras mistas;1;UN
7600;84022000;Caldeiras denominadas de agua superaquecida;1;UN
7601;84029000;Partes de caldeiras de vapor e de agua superaquecida;1;KG
7602;84031010;Caldeiras para aquecimento central, com capacidade inferior ou igual a 200.000 kcal/hora, exceto as da posicao 84.02;1;UN
7603;84031090;Outras caldeiras para aquecimento central, exceto as da posicao 84.02;1;UN
7604;84039000;Partes de caldeiras para aquecimento central;1;KG
7605;84041010;Aparelhos auxiliares para caldeiras de vapor/agua superaquecida;1;UN
7606;84041020;Aparelhos auxiliares para caldeiras de aquecimento central (posicao 8403);1;UN
7607;84042000;Condensadores para maquinas a vapor;1;UN
7608;84049010;Partes de aparelhos auxiliares para caldeiras de vapor, etc;1;KG
7609;84049090;Partes de aparelhos auxilliares para caldeiras aquecimento central;1;KG
7610;84051000;Geradores de gas de ar (gas pobre) ou de gas de agua, com ou sem depuradores, geradores de acetileno e geradores semelhantes de gas, operados a agua, com ou sem depuradores;1;UN
7611;84059000;Partes de geradores de gas de ar/gas de agua, etc.;1;KG
7612;84061000;Turbinas para propulsao de embarcacoes, a  vapor;1;UN
7613;84068100;Outras turbinas a vapor, de potencia superior a 40 MW;1;UN
7614;84068200;Outras turbinas a vapor, de potencia nao superior a 40 MW;1;UN
7615;84069011;Rotores de turbinas a reacao, de multiplos estagios, a vapor;1;KG
7616;84069019;Outros rotores de turbinas a vapor;1;KG
7617;84069021;Palhetas fixas (de estator), de turbinas a vapor;1;KG
7618;84069029;Outras palhetas de turbinas a vapor;1;KG
7619;84069090;Outras partes de turbinas a vapor;1;KG
7620;84071000;Motores de explosao, para aviacao;1;UN
7621;84072110;Motores para propulsao de embarcacoes, de ignicao por centelha (motores de explosao), do tipo fora-de-borda, monocilindricos;1;UN
7622;84072190;Outros motores de explosao, para embarcacao, do tipo fora-de-borda;1;UN
7623;84072910;Outros motores de explosao, para embarcacao, monocilindricos;1;UN
7624;84072990;Outros motores de explosao, para embarcacao;1;UN
7625;84073110;Motores de explosao, para veiculos do capitulo 87, de cilindrada nao superior a 50 cm3, monocilindricos;1;UN
7626;84073190;Outros motores de explosao para veiculos do capitulo 87, de cilindrada nao superior a 50 cm3;1;UN
7627;84073200;Motores de explosao, para veiculos do capitulo 87, de cilindrada superior a 50 cm3, mas nao superior a 250 cm3;1;UN
7628;84073310;Motores de explosao, para veiculos do capitulo 87, ee cilindrada superior a 250 cm3, mas nao superior a 1.000 cm3. monocilindiros;1;UN
7629;84073390;Outros motores de explosao, para veiculos do capitulo 87, de cilindrada superior a 250 cm3, mas nao superior a 1.000 cm3;1;UN
7630;84073410;Motores de explosao, para veiculos do capitulo 87, de cilindrada superior a 1.000 cm3, monocilindricos;1;UN
7631;84073490;Outros motores de explosao, para veiculos do capitulo 87, de cilindrada superior a 1.000 cm3;1;UN
7632;84079000;Outros motores de explosao;1;UN
7633;84081010;Motores diesel/semidiesel, para embarcacao, tipo outboard;1;UN
7634;84081090;Outros motores diesel/semidiesel, para embarcacao;1;UN
7635;84082010;Motores diesel/semidiesel, para viculos do capitulo 87, potencia ate 1500 cm3;1;UN
7636;84082020;Motores diesel/semidiesel, para veiculos do capitulo 87,  1500 < cm3 <=2500;1;UN
7637;84082030;Motores diesel/semidiesel, para veiculos do capitulo 87,  2500 < cm3 <= 3500;1;UN
7638;84082090;Outros motores diesel/semidiesel, para veiculos do capitulo 87;1;UN
7639;84089010;Outros motores diesel, estacionarios, potencia >= 337,5 kw, rpm > 1000;1;UN
7640;84089090;Outros motores diesel/semidiesel;1;UN
7641;84091000;Partes de motores para aviacao;1;KG
7642;84099111;Bielas para motores de explosao;1;UN
7643;84099112;Blocos de cilindros, cabecotes, etc, para motores de explosao;1;UN
7644;84099113;Carburadores para motores de explosao;1;UN
7645;84099114;Valvulas de admissao ou de escape, para motores de explosao;1;UN
7646;84099115;Coletores de admissao ou escape, para motores de explosao;1;UN
7647;84099116;Aneis de segmento, para motores de explosao;1;UN
7648;84099117;Guias de valvulas, para motores de explosao;1;UN
7649;84099118;Outros carburadores para motores de pistao;1;UN
7650;84099120;Pistoes ou embolos, para motores de explosao;1;UN
7651;84099130;Camisas de cilindro, para motores de explosao;1;UN
7652;84099140;Injecao eletronica, para motores de explosao;1;UN
7653;84099190;Outras partes para motores de explosao;1;KG
7654;84099912;Blocos de cilindros, cabecotes, etc, para motores diesel/semi;1;UN
7655;84099914;Valvulas de admissao ou de escape, para motores diesel/semi;1;UN
7656;84099915;Coletores de admissao ou escape, para motores diesel/semi;1;UN
7657;84099917;Guias de valvulas, para motores diesel ou semidiesel;1;UN
7658;84099921;Pistoes/embolos, com diametro superior ou igual a 200 mm, para motores diesel/semidiesel;1;UN
7659;84099929;Outros pistoes ou embolos, para motores diesel/semidiesel;1;UN
7660;84099930;Camisas de cilindro, para motores diesel ou semidiesel;1;UN
7661;84099941;Bielas com peso superior ou igual a 30 kg, para motores diesel/semidiesel;1;UN
7662;84099949;Outras bielas, para motores diesel/semidiesel;1;UN
7663;84099951;Cabecotes, com diametro superior ou igual a 200 mm, para motores/semidiesel;1;UN
7664;84099959;Outros cabecotes para motores diesel/semidiesel;1;UN
7665;84099961;Injetores/bicos injetores, com diametro superior ou igual a 20 mm, para motores diesel/semidiesel;1;UN
7666;84099969;Outros injetores para motores diesel/semidiesel;1;UN
7667;84099971;Aneis de segmento, com diametro superior ou igual a 200 mm, para motores diesel/semidi;1;UN
7668;84099979;Outros aneis de segmento, para motores diesel/semidiesel;1;UN
7669;84099991;Camisas de cilindro soldadas a cabecotes, com diametro superior ou igual a 200 mm;1;KG
7670;84099999;Outras partes para motores diesel e semidiesel;1;KG
7671;84101100;Turbinas e rodas hidraulicas, de potencia nao superior a 1.000 kW;1;UN
7672;84101200;Turbinas e rodas hidraulicas, de potencia superior a 1.000 kW, mas nao superior a 10.000 kW;1;UN
7673;84101300;Turbinas e rodas hidraulicas, de potencia superior a 10.000 kW;1;UN
7674;84109000;Partes de turbinas e rodas hidraulicas, inclusive reguladores;1;KG
7675;84111100;Turborreatores de empuxo nao superior a 25 kN;1;UN
7676;84111200;Turborreatores de empuxo superior a 25 kN;1;UN
7677;84112100;Turbopropulsores de potencia nao superior a 1.100 kW;1;UN
7678;84112200;Turbopropulsores de potencia superior a 1.100 kW;1;UN
7679;84118100;Outras turbinas a gas, de potencia nao superior a 5.000 kW;1;UN
7680;84118200;Outras turbinas a gas, de potencia superior a 5.000 kW;1;UN
7681;84119100;Partes de turborreatores ou de turbopropulsores;1;KG
7682;84119900;Partes de outras turbinas a gas;1;KG
7683;84121000;Propulsores a reacao, exceto os turborreatores;1;UN
7684;84122110;Cilindros hidraulicos;1;UN
7685;84122190;Outros motores hidraulicos, de movimento retilineo;1;UN
7686;84122900;Outros motores hidraulicos;1;UN
7687;84123110;Cilindros pneumaticos;1;UN
7688;84123190;Outros motores pneumaticos, de movimento retilineo;1;UN
7689;84123900;Outros motores pneumaticos;1;UN
7690;84128000;Outros motores e maquinas motrizes;1;UN
7691;84129010;Partes de propulsores a reacao;1;KG
7692;84129020;Partes de maquinas a vapor, de movimento retilineo;1;KG
7693;84129080;Partes de motores hidraulicos/pneumaticos, de movimento retilineo;1;KG
7694;84129090;Partes de outros motores e maquinas motrizes;1;KG
7695;84131100;Bombas para distribuicao de combustiveis ou lubrificantes, dos tipos utilizados em postos de servico ou garagens;1;UN
7696;84131900;Outras bombas com dispositivo medidor ou concebidas para comporta-lo;1;UN
7697;84132000;Bombas para liquidos, manuais, exceto das subposicoes 8413.11 ou 8413.19;1;UN
7698;84133010;Bombas para gasolina ou alcool, proprias para motores de ignicao por centelha ou por compressao;1;UN
7699;84133020;Bombas injetoras de combustivel, proprias para motores de ignicao por centelha ou por compressao;1;UN
7700;84133030;Bombas para oleo lubrificante, para motor a explosao/diesel/semi;1;UN
7701;84133090;Outras bombas para combustiveis, etc, para motor a explosao/diesel;1;UN
7702;84134000;Bombas para concreto (betao);1;UN
7703;84135010;Outras bombas volumetricas alternativas, de potencia superior a 3,73 kW (5 HP) e inferior ou igual a 447,42 kW (600 HP), excluidas as para oxigenio liquido;1;UN
7704;84135090;Outras bombas volumetricas alternativas;1;UN
7705;84136011;Bombas volumetricas rotativas, de vazao inferior ou igual a 300 l/min, de engrenagem;1;UN
7706;84136019;Outras bombas volumetricas rotativas, de vazao inferior ou igual a 300 l/min;1;UN
7707;84136090;Outras bombas volumetricas rotativas;1;UN
7708;84137010;Eletrobombas submersiveis;1;UN
7709;84137080;Outras bombas centrifugas, de vazao inferior ou igual a 300 l/min;1;UN
7710;84137090;Outras bombas centrifugas;1;UN
7711;84138100;Outras bombas para liquidos;1;UN
7712;84138200;Elevadores de liquidos;1;UN
7713;84139110;Hastes de bombeamento para extracao de petroleo;1;KG
7714;84139190;Outras partes de bombas para liquidos;1;KG
7715;84139200;Partes de elevadores de liquidos;1;KG
7716;84141000;Bombas de vacuo;1;UN
7717;84142000;Bombas de ar, de mao ou de pe;1;UN
7718;84143011;Motocompressores hermeticos, com capacidade inferior a 4.700 frigorias/hora, dos tipos utilizados nos equipamentos frigorificos;1;UN
7719;84143019;Outros motocompressores hermetico, dos tipos utilizados nos equipamentos frigorificos;1;UN
7720;84143091;Compressor para equipamento frigorifico, capacidade <= 16000 frigorias/hora;1;UN
7721;84143099;Outros compressores para equipamentos frigorificos;1;UN
7722;84144010;Compressores de ar montados sobre chassis com rodas e rebocaveis, de deslocamento alternativo;1;UN
7723;84144020;Compressores de ar montados sobre chassis com rodas e rebocaveis, de parafuso;1;UN
7724;84144090;Outros compressores de ar, montados sobre chassis com rodas e rebocaveis;1;UN
7725;84145110;Ventiladores de mesa, com motor eletrico incorporado de potencia nao superior a 125 W;1;UN
7726;84145120;Ventiladores de teto, com motor eletrico incorporado de potencia nao superior a 125 W;1;UN
7727;84145190;Outros ventiladores com motor eletrico incorporado de potencia nao superior a 125 W;1;UN
7728;84145910;Microventiladores com area de carcaca inferior a 90 cm2;1;UN
7729;84145990;Outros ventiladores;1;UN
7730;84146000;Coifas com dimensao horizontal maxima nao superior a 120 cm;1;UN
7731;84148011;Outros compressores de ar, estacionarios, de pistao;1;UN
7732;84148012;Outros compressores de ar, de parafuso;1;UN
7733;84148013;Outros compressores de ar, de lobulos paralelos (roots);1;UN
7734;84148019;Outros compressores de ar;1;UN
7735;84148021;Turboalimentadores de ar, de peso inferior ou igual a 50 kg para motores das posicoes 84.07 ou 84.08 (motor a explosao/diesel), acionado pelos gases de escapamento dos mesmos;1;UN
7736;84148022;Turboalimentadores de ar, de peso superior a 50 kg para motores das posicoes 84.07 ou 84.08 (motor a explosao/diesel), acionados pelos gases de escapamento dos mesmos;1;UN
7737;84148029;Outros turbocompressores de ar;1;UN
7738;84148031;Outros compressores de gases, de pistao;1;UN
7739;84148032;Outros compressores de gases, de parafuso;1;UN
7740;84148033;Outros compressores de gases, centrifugos, de vazao maxima inferior a 22.000 m3/h;1;UN
7741;84148038;Outros compressores de gases, centrifugos;1;UN
7742;84148039;Outros compressores de gases;1;UN
7743;84148090;Outras bombas de ar/coifas aspirantes para extracao/reciclagem;1;UN
7744;84149010;Partes de bombas de ar ou de vacuo;1;KG
7745;84149020;Partes de ventiladores ou coifas aspirantes;1;KG
7746;84149031;Pistoes ou embolos, de compressores de ar/outros gases;1;UN
7747;84149032;Aneis de segmento, para compressores de ar ou outros gases;1;UN
7748;84149033;Blocos de cilindros, cabecotes e carteres, para compressores;1;UN
7749;84149034;Valvulas de compressores de ar/outros gases;1;UN
7750;84149039;Outras partes de compressores de ar/outros gases;1;KG
7751;84151011;Aparelhos de ar condicionado do tipo split-system (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora, utilizados em paredes ou janelas;1;UN
7752;84151019;Outros aparelhos de ar condicionado com capacidade inferior ou igual a 30.000 frigorias/hora, utilizados em paredes ou janelas;1;UN
7753;84151090;Outros aparelhos de ar condicionado, para janelas, etc.;1;UN
7754;84152010;Aparelhos de ar-condicionado, com capacidade inferior ou igual a 30.000 frigorias/hora, do tipo dos utilizados para o conforto dos passageiros nos veiculos automoveis;1;UN
7755;84152090;Outros aparelhos de ar-condicionado, do tipo dos utilizados para o conforto dos passageiros nos veiculos automoveis;1;UN
7756;84158110;Outros aparelhos de ar condicionado, com dispositivo de refrigeracao e valvula de inversao do ciclo termico (bombas de calor reversiveis), com capacidade inferior ou igual a 30.000 frigorias/hora;1;UN
7757;84158190;Outros aparelhos de ar condicionado, com dispositivo de refrigeracao e valvula de inversao do ciclo termico (bombas de calor reversiveis);1;UN
7758;84158210;Outros aparelhos de ar condicionado, com dispositivo de refrigeracao, com capacidade inferior ou igual a 30.000 frigorias/hora;1;UN
7759;84158290;Outros aparelhos de ar condicionado, com dispositivo de refrigeracao;1;UN
7760;84158300;Outros aparelhos de ar condicionado, sem dispositivo de refrigeracao;1;UN
7761;84159010;Unidades evaporadoras (internas) de aparelho de ar-condicionado do tipo split-system (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora;1;KG
7762;84159020;Unidades condensadoras (externas) de aparelho de ar-condicionado do tipo split-system (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora;1;KG
7763;84159090;Outras unidades de ar condicionado;1;KG
7764;84161000;Queimadores para alimentacao de fornalhas, de combustiveis liquidos;1;UN
7765;84162010;Queimadores para alimentacao de fornalhas, de gases;1;UN
7766;84162090;Outros queimadores para alimentacao de fornalhas, inclusive os mistos;1;UN
7767;84163000;Fornalhas automaticas, incluindo as antefornalhas, grelhas mecanicas, descarregadores mecanicos de cinzas e dispositivos semelhantes;1;UN
7768;84169000;Partes de queimadores, fornalhas automativas, etc.;1;KG
7769;84171010;Fornos industriais para fusao de metais, nao eletricos;1;UN
7770;84171020;Fornos industriais para tratamento termico de metais, nao eletricos;1;UN
7771;84171090;Outros fornos para ustulacao, etc, de minerios/metais, nao eletricos;1;UN
7772;84172000;Fornos de padaria, pastelaria ou para a industria de bolachas e biscoitos, nao eletricos;1;UN
7773;84178010;Fornos industriais para ceramica, nao eletricos;1;UN
7774;84178020;Fornos industriais para fusao de vidro, nao eletricos;1;UN
7775;84178090;Outros fornos industriais ou de laboratorio, nao eletricos;1;UN
7776;84179000;Partes de fornos industriais ou de laboratorio, nao eletricos;1;KG
7777;84181000;Combinacoes de refrigeradores e congeladores (freezers), munidos de portas exteriores separadas;1;UN
7778;84182100;Refrigeradores do tipo domestico, de compressao;1;UN
7779;84182900;Outros refrigeradores do tipo domestico;1;UN
7780;84183000;Congeladores (freezers) horizontais tipo arca, de capacidade nao superior a 800 litros;1;UN
7781;84184000;Congeladores (freezers) verticais tipo armario, de capacidade nao superior a 900 litros;1;UN
7782;84185010;Outros congeladores (freezers);1;UN
7783;84185090;Outros moveis (arcas, armarios, vitrines, balcoes e moveis semelhantes) para a conservacao e exposicao de produtos, que incorporem um equipamento para a producao de frio;1;UN
7784;84186100;Bombas de calor, excluindo as maquinas e aparelhos de ar-condicionado da posicao 8415;1;UN
7785;84186910;Maquinas para preparacao de sorvetes, nao domesticas;1;UN
7786;84186920;Resfriadores de leite;1;UN
7787;84186931;Unidades fornecedoras de agua ou sucos;1;UN
7788;84186932;Unidades fornecedoras de bebidas carbonatadas;1;UN
7789;84186940;Grupos frigorificos de compressao com capacidade inferior ou igual a 30.000 frigorias/hora;1;UN
7790;84186991;Resfriadores de agua, de absorcao por brometo de litio;1;UN
7791;84186999;Outros materiais/maquinas/aparelhos, para produzir frio, e bombas de calor;1;UN
7792;84189100;Moveis concebidos para receber um equipamento para a producao de frio;1;UN
7793;84189900;Outras partes de refrigeradores, congeladores, etc.;1;KG
7794;84191100;Aquecedores de agua, de aquecimento instantaneo, a gas;1;UN
7795;84191910;Aquecedores solares de agua;1;UN
7796;84191990;Outros aquecedores de agua, nao eletricos, de aquecimento instantaneo, etc;1;UN
7797;84192000;Esterilizadores medico-cirurgicos ou de laboratorio;1;UN
7798;84193100;Secadores para produtos agricolas;1;UN
7799;84193200;Secadores para madeiras, pastas de papel, papeis ou cartoes;1;UN
7800;84193900;Outros secadores;1;UN
7801;84194010;Aparelhos de destilacao de agua;1;UN
7802;84194020;Aparelhos de destilacao ou retificacao de alcoois e outros fluidos volateis ou de hidrocarbonetos;1;UN
7803;84194090;Outros aparelhos de destilacao ou de retificacao;1;UN
7804;84195010;Trocadores de calor, de placas;1;UN
7805;84195021;Trocadores de calor, tubulares, metalicos;1;UN
7806;84195022;Trocadores de calor, tubulares, de grafite;1;UN
7807;84195029;Outros trocadores de calor, tubulares;1;UN
7808;84195090;Outros trocadores de calor;1;UN
7809;84196000;Aparelhos e dispositivos para liquefacao do ar ou de outros gases;1;UN
7810;84198110;Autoclaves para preparacao de bebidas quentes ou para cozimento ou aquecimento de alimentos;1;UN
7811;84198190;Outros aparelhos/dispositivos para preparacao de bebidas quentes, etc;1;UN
7812;84198911;Esterilizadores de alimentos, mediante Ultra Alta Temperatura (UHT - Ultra High Temperature) por injecao direta de vapor, com capacidade superior ou igual a 6.500 l/h;1;UN
7813;84198919;Outros esterilizadores;1;UN
7814;84198920;Estufas;1;UN
7815;84198930;Torrefadores;1;UN
7816;84198940;Evaporadores;1;UN
7817;84198991;Recipiente refrigerador, com dispositivo de circulacao de fluido refrigerante;1;UN
7818;84198999;Outros aparelhos e dispositivos para tratamento de materias por meio de operacoes que impliquem mudanca de temperatura;1;UN
7819;84199010;Partes de aquecedores de agua das subposicoes 8419.11 ou 8419.19;1;KG
7820;84199020;Partes de colunas de destilacao ou de retificacao;1;KG
7821;84199031;Placa corrugada, de aco inoxidavel ou de aluminio, com superficie de troca termica de area superior a 0,4 m2;1;UN
7822;84199039;Outras placas de trocadores (permutadores) de calor;1;KG
7823;84199040;Partes de aparelhos e dispositivos para preparacao de bebida quente, etc;1;KG
7824;84199090;Outras partes de aparelhos e dispositivos para tratamento de materias por meio de operacoes que impliquem mudanca de temperatura;1;KG
7825;84201010;Calandras e laminadores, para papel ou cartao;1;UN
7826;84201090;Outras calandras e laminadores;1;UN
7827;84209100;Cilindros para calandras e laminadores;1;UN
7828;84209900;Outras partes para calandras e laminadores;1;KG
7829;84211110;Desnatadeira centrifuga, com capacidade de processamento de leite superior ou igual a 30.000 l/h;1;UN
7830;84211190;Outras desnatadeiras centrifugas;1;UN
7831;84211210;Secador de roupa, centrifugo, com capacidade, expressa em peso de roupa seca, inferior ou igual a 6 kg;1;UN
7832;84211290;Outras secadores de roupa, centrifugos;1;UN
7833;84211910;Centrifugadores para laboratorios de analises, ensaios ou pesquisas cientificas;1;UN
7834;84211990;Outros centrifugadores;1;UN
7835;84212100;Aparelhos para filtrar ou depurar agua;1;UN
7836;84212200;Aparelhos para filtrar ou depurar bebidas, exceto agua;1;UN
7837;84212300;Aparelhos para filtrar oleos minerais nos motores de ignicao por centelha ou por compressao;1;UN
7838;84212911;Hemodialisadores capilares;1;UN
7839;84212919;Outros hemodialisadores;1;UN
7840;84212920;Aparelhos de osmose inversa;1;UN
7841;84212930;Filtros-prensas para liquidos;1;UN
7842;84212990;Outros aparelhos para filtrar ou depurar liquidos;1;UN
7843;84213100;Filtros de entrada de ar para motores de ignicao por centelha ou por compressao;1;UN
7844;84213910;Filtros eletrostaticos para gases;1;UN
7845;84213920;Depuradores por conversao catalitica de gases de escape de veiculos;1;UN
7846;84213930;Concentradores de oxigenio por depuracao do ar, com capacidade de saida inferior ou igual a 6 l/min;1;UN
7847;84213990;Outros aparelhos para filtrar ou depurar gases;1;UN
7848;84219110;Partes de secadores de roupa, centrifugos, capacidade de roupa <= 6 kg;1;KG
7849;84219191;Tambores rotativos com pratos ou discos separadores, de peso superior a 300 kg;1;UN
7850;84219199;Outras partes de centrifugadores;1;KG
7851;84219910;Partes de outros aparelhos para filtrar ou depurar gases;1;KG
7852;84219920;Partes de aparelhos para utilizacao de linhas de sangue para hemodialise;1;KG
7853;84219991;Cartuchos de membrana de aparelhos de osmose inversa;1;KG
7854;84219999;Outras partes de aparelhos para filtrar ou depurar liquidos, etc.;1;KG
7855;84221100;Maquinas de lavar louca, do tipo domestico;1;UN
7856;84221900;Outras maquinas de lavar louca;1;UN
7857;84222000;Maquinas e aparelhos para limpar ou secar garrafas ou outros recipientes;1;UN
7858;84223010;Maquinas e aparelhos para encher, fechar, arrolhar, capsular ou rotular garrafas;1;UN
7859;84223021;Maquinas e aparelhos para encher caixas ou sacos com po ou graos;1;UN
7860;84223022;Maquinas e aparelhos para encher e fechar embalagens confeccionadas com papel ou cartao dos subitens 4811.51.22 ou 4811.59.23, mesmo com dispositivo de rotulagem;1;UN
7861;84223023;Maquinas e aparelhos para encher e fechar recipientes tubulares flexiveis (bisnagas), com capacidade superior ou igual a 100 unidades por minuto;1;UN
7862;84223029;Maquinas e aparelhos para encher/fechar latas, capsular vasos, etc.;1;UN
7863;84223030;Maquinas e aparelhos para gaseificar bebidas;1;UN
7864;84224010;Maquinas horizontais, proprias para empacotamento de massas alimenticias longas (comprimento superior a 200 mm) em pacotes tipo almofadas (pillow pack), com capacidade de producao superior a 100 pacotes por minuto e controlador logico programavel (CLP);1;UN
7865;84224020;Maquina automatica, para embalar tubos ou barras de metal, em atados de peso inferior ou igual a 2.000 kg e comprimento inferior ou igual a 12 m;1;UN
7866;84224030;Maquinas e aparelhos de empacotar embalagens confeccionadas com papel ou cartao dos subitens 4811.51.22 ou 4811.59.23 em caixas ou bandejas de papel ou cartao dobraveis, com capacidade superior ou igual a 5.000 embalagens por hora;1;UN
7867;84224090;Outras maquinas e aparelhos para empacotar/embalar mercadorias;1;UN
7868;84229010;Partes de maquinas para lavar loucas, de uso domestico;1;KG
7869;84229090;Partes de maquinas e aparelhos para limpar, secar, encher, fechar, etc;1;KG
7870;84231000;Balancas para pessoas, incluindo as balancas para bebes, balancas de uso domestico;1;UN
7871;84232000;Basculas de pesagem continua em transportadores;1;UN
7872;84233011;Basculas dosadoras, com aparelhos perifericos, que constituam unidade funcional;1;UN
7873;84233019;Outras basculas dosadoras;1;UN
7874;84233090;Basculas de pesagem constante e basculas ensacadoras;1;UN
7875;84238110;Outros aparelhos e instrumentos de pesagem, de capacidade nao superior a 30 kg, de mesa, com dispositivo registrador ou impressor de etiquetas;1;UN
7876;84238190;Outros aparelhos e instrumentos de pesagem, de capacidade nao superior a 30 kg;1;UN
7877;84238200;Aparelhos e instrumentos pesagem, de capacidade superior a 30 kg, mas nao superior a 5.000 kg;1;UN
7878;84238900;Outros aparelhos e instrumentos de pesagem;1;UN
7879;84239010;Pesos para balancas;1;KG
7880;84239021;Partes de balancas para pessoas, inclusive para bebes, uso domestico;1;KG
7881;84239029;Partes de outros aparelhos e instrumentos de pesagem, inclusive bascula;1;KG
7882;84241000;Extintores, mesmo carregados;1;UN
7883;84242000;Pistolas aerograficas e aparelhos semelhantes;1;UN
7884;84243010;Maquinas e aparelhos de desobstrucao de tubulacao ou de limpeza, por jato de agua;1;UN
7885;84243020;Maquinas e aparelhos de jato de areia, propria para desgaste localizado de pecas de vestuario;1;UN
7886;84243030;Perfuradoras por jato de agua com pressao de trabalho maxima superior ou igual a 10 MPa;1;UN
7887;84243090;Outras maquinas e aparelhos de jato de areia/jato de vapor, etc.;1;UN
7888;84244100;Pulverizadores portateis, para agricultura ou horticultura;1;UN
7889;84244900;Outros pulverizadores, para a agricultura ou horticultura;1;UN
7890;84248221;Irrigadores e sistemas de irrigacao por aspersao, para agricultura ou horticultura;1;UN
7891;84248229;Irrigadores e sistemas de irrigacao para a agricultura ou horticultura, exceto por aspersao;1;UN
7892;84248290;Outros aparelhos para agricultura ou horticultura;1;UN
7893;84248910;Aparelho de pulverizacao constituido por botao de pressao com bocal,valvula tipo aerossol,junta de estanqueidade e tubo de imersao,montado sobre um corpo metalico,utilizado para ser montado no gargalo de recipientes,para projetar liquidos,pos ou espumas;1;UN
7894;84248920;Aparelhos automaticos para projetar lubrificantes sobre pneumaticos, contendo uma estacao de secagem por ar pre-aquecido e dispositivos para agarrar e movimentar pneumaticos;1;UN
7895;84248990;Outros aparelhos mecanicos, para projetar, etc, liquidos, pos;1;UN
7896;84249010;Partes de extintores/aparelhos para pulverizar, etc, manuais;1;KG
7897;84249090;Partes de outros aparelhos mecanicos para projetar, etc, liquidos/pos, etc;1;KG
7898;84251100;Talhas, cadernais e moitoes, de motor eletrico;1;UN
7899;84251910;Talhas, cadernais e moitoes, manuais;1;UN
7900;84251990;Outras talhas, cadernais e moitoes;1;UN
7901;84253110;Guinchos, cabrestantes, de motor eletrico, com capacidade inferior ou igual a 100 toneladas;1;UN
7902;84253190;Outros guinchos e cabrestantes, de motor eletrico, com capacidade inferior ou igual a 100 toneladas;1;UN
7903;84253910;Outros guinchos e cabrestantes, com capacidade inferior ou igual a 100 toneladas;1;UN
7904;84253990;Outros guinchos e cabrestantes;1;UN
7905;84254100;Macacos elevadores fixos de veiculos, para garagens (oficinas);1;UN
7906;84254200;Outros macacos, hidraulicos;1;UN
7907;84254910;Macacos manuais;1;UN
7908;84254990;Outros macacos;1;UN
7909;84261100;Pontes e vigas, rolantes, de suportes fixos;1;UN
7910;84261200;Porticos moveis de pneumaticos e carros-porticos;1;UN
7911;84261900;Outros porticos e pontes-guindastes;1;UN
7912;84262000;Guindastes de torre;1;UN
7913;84263000;Guindastes de portico;1;UN
7914;84264110;Maquinas e aparelhos autopropulsados, de pneumaticos, com deslocamento em sentido longitudinal, transversal e diagonal (tipo caranguejo) com capacidade de carga superior ou igual a 60 toneladas;1;UN
7915;84264190;Outras maquinas e aparelhos autopropulsados, de pneumaticos;1;UN
7916;84264910;Maquinas e aparelhos autopropulsados, de lagartas, com capacidade de elevacao superior ou igual a 70 toneladas;1;UN
7917;84264990;Outras maquinas e aparelhos autopropulsados;1;UN
7918;84269100;Maquinas e aparelhos para montagem em veiculos rodoviarios;1;UN
7919;84269900;Cabreas e outros guindastes;1;UN
7920;84271011;Empilhadeiras autopropulsadas, de motor eletrico, de capacidade de carga superior a 6,5 toneladas;1;UN
7921;84271019;Outras empilhadeiras autopropulsadas, de motor eletrico;1;UN
7922;84271090;Outros veiculos para movimentacao de carga, autopropulsados, de motor eletrico;1;UN
7923;84272010;Empilhadeiras com capacidade de carga superior a 6,5 toneladas, autopropulsadas;1;UN
7924;84272090;Outros veiculos para movimentar carga, autopropulsados;1;UN
7925;84279000;Outras empilhadeiras e veiculos para movimentacao de carga, equipados com dispositivos de elevacao;1;UN
7926;84281000;Elevadores e monta-cargas;1;UN
7927;84282010;Transportadores tubulares (transvasadores) moveis, acionados com motor de potencia superior a 90 kW (120 HP), pneumaticos;1;UN
7928;84282090;Outros aparelhos elevadores ou transportadores, pneumaticos;1;UN
7929;84283100;Aparelhos elevadores ou transportadores, de acao continua, para mercadorias, especialmente concebidos para uso subterraneo;1;UN
7930;84283200;Aparelhos elevadores ou transportadores, de acao continua, para mercadorias, de cacamba;1;UN
7931;84283300;Aparelhos elevadores ou transportadores, de acao continua, para mercadorias, de tira ou correia;1;UN
7932;84283910;Aparelhos elevadores ou transportadores, de acao continua, para mercadorias, de correntes;1;UN
7933;84283920;Aparelhos elevadores ou transportadores, de acao continua, para mercadorias, de rolos motores;1;UN
7934;84283930;Aparelhos elevadores ou transportadores, de acao continua, para mercadorias, de pincas laterais, do tipo dos utilizados para o transporte de jornais;1;UN
7935;84283990;Outros aparelhos elevadores ou transportadores, de acao continua, para mercadorias;1;UN
7936;84284000;Escadas e tapetes, rolantes;1;UN
7937;84286000;Telefericos (incluindo as telecadeiras e os telesquis), mecanismos de tracao para funiculares;1;UN
7938;84289010;Maquinas e aparelhos do tipo dos utilizados para desembarque de botes salva-vidas, motorizados ou providos de dispositivo de compensacao de inclinacao;1;UN
7939;84289020;Transportadores-elevadores (transelevadores) automaticos, de deslocamento horizontal sobre guias;1;UN
7940;84289030;Maquina para formacao de pilhas de jornais, dispostos em sentido alternado, de capacidade superior ou igual a 80.000 exemplares/h;1;UN
7941;84289090;Outras maquinas e aparelhos de elevacao, de carga, de descarga, etc.;1;UN
7942;84291110;Bulldozers e Angledozers, de lagartas, de potencia no volante superior ou igual a 387,76 kW (520 HP);1;UN
7943;84291190;Outros bulldozers e angledozers, de lagartas;1;UN
7944;84291910;Outros bulldozers de potencia no volante >= 315 hp;1;UN
7945;84291990;Outros bulldozers e angledozers;1;UN
7946;84292010;Motoniveladores articulados, de potencia no volante superior ou igual a 205,07 kW (275 HP);1;UN
7947;84292090;Outros niveladores;1;UN
7948;84293000;Raspo-transportadores, autopropulsores;1;UN
7949;84294000;Compactadores e rolos ou cilindros compressores, autopropulsados;1;UN
7950;84295111;Carregadoras-transportadoras, do tipo das utilizadas em minas subterraneas;1;UN
7951;84295119;Outras carregadoras-transportadoras de carregamento frontal;1;UN
7952;84295121;Infraestruturas motoras, proprias para receber carregadoras (item 8430.69.1), de potencia no volante superior ou igual a 454,13 kW (609 HP);1;UN
7953;84295129;Infraestrutura motora, para receber outras carregadoras;1;UN
7954;84295191;Carregadoras e pas carregadoras, de potencia no volante superior ou igual a 297,5 kW (399 HP), de carregamento frontal;1;UN
7955;84295192;Carregadoras e pas carregadoras, de potencia no volante inferior ou igual a 43,99 kW (59 HP);1;UN
7956;84295199;Outras carregadoras e pas carregadoras, de carregamento frontal;1;UN
7957;84295211;Escavadoras, de potencia no volante superior ou igual a 484,7 kW (650 HP), cuja superestrutura e capaz de efetuar uma rotacao de 360�;1;UN
7958;84295212;Escavadoras, de potencia no volante inferior ou igual a 40,3 kW (54 HP), cuja superestrutura e capaz de efetuar uma rotacao de 360�;1;UN
7959;84295219;Outras escavadoras, cuja superestrutura e capaz de efetuar uma rotacao de 360�;1;UN
7960;84295220;Infraestruturas motoras, proprias para receber equipamentos das subposicoes 8430.49, 8430.61 ou 8430.69, mesmo com dispositivo de deslocamento sobre trilhos;1;UN
7961;84295290;Outras maquinas escavadoras, etc, cuja superestrutura e capaz de efetuar uma rotacao de 360�;1;UN
7962;84295900;Outras pas mecanicas, escavadores, carregadoras, etc.;1;UN
7963;84301000;Bate-estacas e arranca-estacas;1;UN
7964;84302000;Limpa-neves;1;UN
7965;84303110;Cortadores de carvao ou de rocha, autopropulsados;1;UN
7966;84303190;Maquinas para perfuracao de tuneis e galerias, autopropulsoras;1;UN
7967;84303910;Outros cortadores de carvao ou de rocha;1;UN
7968;84303990;Outras maquinas para perfuracao de tuneis e galerias;1;UN
7969;84304110;Perfuratriz de percussao, autopropulsada;1;UN
7970;84304120;Perfuratriz rotativa, autopropulsada;1;UN
7971;84304130;Maquinas de sondagem, rotativas, autopropulsada;1;UN
7972;84304190;Outras maquinas de sondagem e perfuracao, autopropulsadas;1;UN
7973;84304910;Outras perfuratrizes de percussao;1;UN
7974;84304920;Outras maquinas de sondagem, rotativas;1;UN
7975;84304990;Outras maquinas de sondagem/perfuracao;1;UN
7976;84305000;Outras partes de maquinas e aparelhos de terraplanagem, etc, autopropulsadas;1;UN
7977;84306100;Maquinas de comprimir ou de compactar terra, exceto autopropulsadas;1;UN
7978;84306911;Equipamentos frontais para escavo-carregadoras ou carregadoras, com capacidade de carga superior a 4 m3;1;UN
7979;84306919;Outros equipamentos frontais para escavo-carregadoras ou carregadoras, exceto autopropulsados;1;UN
7980;84306990;Outras maquinas e aparelhos de terraplanagem, etc, exceto autopropulsados;1;UN
7981;84311010;Partes de talhas, cadernais, moitoes manuais, guinchos, etc;1;KG
7982;84311090;Partes de outras talhas, cadernais, moitoes, guinchos, etc.;1;KG
7983;84312011;Partes de empilhadeiras, autopropulsadas;1;KG
7984;84312019;Partes de outras empilhadeiras;1;KG
7985;84312090;Partes de outros veiculos para movimentacao de carga, com dispositivo de elevacao;1;KG
7986;84313110;Partes de elevadores;1;KG
7987;84313190;Partes de monta-cargas ou de escadas rolantes;1;KG
7988;84313900;Partes de outras maquinas e aparelhos de elevacao de carga, etc.;1;KG
7989;84314100;Cacambas, mesmo de mandibulas, pas, ganchos e tenazes, para maquinas e aparelhos de terraplanagem (aparelhos das posicoes 84.26, 84.29 ou 84.30);1;UN
7990;84314200;Laminas para bulldozers ou angledozers;1;UN
7991;84314310;Partes das maquinas de sondagem rotativas;1;KG
7992;84314390;Partes de outras maquinas de sondagem/perfuracao;1;KG
7993;84314910;Partes de guindastes, outras maquinas e aparelhos de carga/descarga;1;KG
7994;84314921;Cabinas para maquinas e aparelhos de terraplanagem e etc.;1;KG
7995;84314922;Lagartas de maquinas ou aparelhos das posicoes 84.29 ou 84.30;1;KG
7996;84314923;Tanques de combustivel e demais reservatorios;1;KG
7997;84314929;Outras partes de maquinas e aparelhos de terraplanagem etc;1;KG
7998;84321000;Arados e charruas;1;UN
7999;84322100;Grades de discos, de uso agricola, horticola ou florestal, para preparacao ou trabalho do solo ou para cultura;1;UN
8000;84322900;Outras grades, escarificadores, cultivadores, enxadas, etc.;1;UN
8001;84323110;Semeadores-adubadores, de plantio direto;1;UN
8002;84323190;Plantadores e transplantadores, de plantio direto;1;UN
8003;84323910;Semeadores-adubadores, exceto para plantio direto;1;UN
8004;84323990;Plantadores e transplantadores, exceto de plantio direto;1;UN
8005;84324100;Espalhadores de estrume;1;UN
8006;84324200;Distribuidores de adubos (fertilizantes);1;UN
8007;84328000;Outras maquinas e aparelhos de uso agricola, horticola ou florestal, para preparacao ou trabalho do solo;1;UN
8008;84329000;Partes de maquinas e aparelhos de uso agricola, horticola ou florestal, para preparacao ou trabalho do solo;1;KG
8009;84331100;Cortadores de grama, motorizados, cujo dispositivo de corte gira num plano horizontal;1;UN
8010;84331900;Outros cortadores de grama;1;UN
8011;84332010;Ceifeiras, incluindo as barras de corte para montagem em tratores, com dispositivo de acondicionamento em fileiras constituido por rotor de dedos e pente;1;UN
8012;84332090;Outras ceifeiras, incluindo as barras de corte para montagem em tratores;1;UN
8013;84333000;Outras maquinas e aparelhos para colher e dispor o feno;1;UN
8014;84334000;Enfardadeiras de palha ou de forragem, incluindo as enfardadeiras-apanhadeiras;1;UN
8015;84335100;Colheitadeiras combinadas com debulhadoras;1;UN
8016;84335200;Outras maquinas e aparelhos para debulha;1;UN
8017;84335300;Maquinas para colheita de raizes ou tuberculos;1;UN
8018;84335911;Colheitadeiras de algodao, com capacidade para trabalhar ate dois sulcos de colheita e potencia no volante inferior ou igual a 59,7 kW (80 HP);1;UN
8019;84335919;Outras colheitadeiras de algodao;1;UN
8020;84335990;Outras maquinas e aparelhos para colheita;1;UN
8021;84336010;Selecionadores de frutas;1;UN
8022;84336021;Maquinas para limpar ou selecionar ovos, com capacidade superior ou igual a 250.000 ovos por hora;1;UN
8023;84336029;Outras maquinas para limpar ou selecionar ovos;1;UN
8024;84336090;Maquinas para limpar/selecionar ovos e outros produtos agricolas;1;UN
8025;84339010;Partes de cortadores de grama;1;KG
8026;84339090;Partes de outras maquinas e aparelhos para colheita, debulha, etc.;1;KG
8027;84341000;Maquinas de ordenhar;1;UN
8028;84342010;Maquinas e aparelhos para tratamento do leite;1;UN
8029;84342090;Outras maquinas e aparelhos para a industria de lacticinios;1;UN
8030;84349000;Partes de maquinas e aparelhos de ordenhar/industria de laticinios;1;KG
8031;84351000;Maquinas e aparelhos para fabricacao de vinho, sidra, suco de frutas, etc.;1;UN
8032;84359000;Partes de maquinas e aparelhos para fabricacao de vinho, sidra, etc.;1;KG
8033;84361000;Maquinas e aparelhos para preparacao de alimentos ou racoes para animais;1;UN
8034;84362100;Chocadeiras e criadeiras, para avicultura;1;UN
8035;84362900;Outras maquinas e aparelhos para avicultura;1;UN
8036;84368000;Outras maquinas e aparelhos para agricultura, horticultura, etc;1;UN
8037;84369100;Partes de maquinas e aparelhos para avicultura;1;KG
8038;84369900;Partes de maquinas e aparelhos para agricultura, horticultura, etc.;1;KG
8039;84371000;Maquinas para limpeza, selecao, etc, de graos, produtos horticolas, secos;1;UN
8040;84378010;Maquinas e aparelhos para trituracao ou moagem de graos;1;UN
8041;84378090;Outras maquinas e aparelhos para a industria de moagem, tratamento de cereais, etc;1;UN
8042;84379000;Partes de maquinas e aparelhos para limpeza, selecao, etc, de graos;1;KG
8043;84381000;Maquinas e aparelhos para industria de panificacao, pastelaria, etc.;1;UN
8044;84382011;Maquinas e aparelhos para fabricar bombons de chocolate por moldagem, de capacidade de producao superior ou igual a 150 kg/h;1;UN
8045;84382019;Outras maquinas e aparelhos para industrias de confeitaria;1;UN
8046;84382090;Maquinas e aparelhos para industria de cacau ou de chocolate;1;UN
8047;84383000;Maquinas e aparelhos para a industria de acucar;1;UN
8048;84384000;Maquinas e aparelhos para a industria cervejeira;1;UN
8049;84385000;Maquinas e aparelhos para preparacao de carnes;1;UN
8050;84386000;Maquinas e aparelhos para preparacao de frutas ou de produtos horticolas;1;UN
8051;84388010;Maquinas para extracao de oleo essencial de citricos;1;UN
8052;84388020;Maquina automatica, para descabecar, cortar a cauda e eviscerar peixes, com capacidade superior a 350 unidades por minuto;1;UN
8053;84388090;Outras maquinas e aparelhos para preparacao/fabricacao da industria de alimentos, etc.;1;UN
8054;84389000;Partes de maquinas e aparelhos para preparacao/fabricacao de alimentos, etc.;1;KG
8055;84391010;Maquinas e aparelhos para tratamento preliminar das materias primas, para fabricacao de pasta de materias fibrosas celulosicas;1;UN
8056;84391020;Classificadoras e classificadoras-depuradoras de pasta de celulose;1;UN
8057;84391030;Refinadoras para fabricacao de pasta de materia celulosica;1;UN
8058;84391090;Outras maquinas e aparelhos para fabricacao de pasta de materia celulosica;1;UN
8059;84392000;Maquinas e aparelhos para fabricacao de papel ou cartao;1;UN
8060;84393010;Bobinadoras-esticadoras para acabamento de papel ou cartao;1;UN
8061;84393020;Maquinas e aparelhos para impregnar papel ou cartao;1;UN
8062;84393030;Maquinas e aparelhos para ondular papel ou cartao;1;UN
8063;84393090;Outras maquinas e aparelhos para acabamento de papel/cartao;1;UN
8064;84399100;Partes de maquinas e aparelhos para fabricacao de pasta de materia celulosica;1;KG
8065;84399910;Rolos, corrugadores ou de pressao, de maquinas para ondular, com largura util superior ou igual a 2.500 mm;1;KG
8066;84399990;Outras partes de maquinas/aparelhos para fabricacao/acabamento de papel/cartao;1;KG
8067;84401011;Maquinas e aparelhos de costurar cadernos, com alimentacao automatica;1;UN
8068;84401019;Outras maquinas e aparelhos de costurar cadernos;1;UN
8069;84401020;Maquinas para fabricar capas de papelao, com dispositivo de colagem e capacidade de producao superior a 60 unidades por minuto;1;UN
8070;84401090;Outras maquinas e aparelhos para brochura ou encadernacao;1;UN
8071;84409000;Partes de maquinas e aparelhos para brochura ou encadernacao;1;KG
8072;84411010;Cortadeiras bobinadoras com velocidade de bobinado superior a 2.000 m/min;1;UN
8073;84411090;Outras cortadeiras para pasta de papel, papel ou cartao;1;UN
8074;84412000;Maquinas para fabricacao de sacos de quaisquer dimensoes ou de envelopes, de papel;1;UN
8075;84413010;Maquinas de dobrar e colar, para fabricacao de caixas, de papel;1;UN
8076;84413090;Outras maquinas para fabricacao de caixas, tubos, tambores, de papel, etc;1;UN
8077;84414000;Maquinas de moldar artigos de pasta de papel, papel ou cartao;1;UN
8078;84418000;Outras maquinas e aparelhos para trabalho da pasta de papel, papel ou cartao;1;UN
8079;84419000;Partes de maquinas e aparelhos para trabalho da pasta de papel, papel ou cartao;1;KG
8080;84423010;Maquinas, aparelhos e equipamentos, de compor por processo fotografico;1;UN
8081;84423020;Maquinas, aparelhos e equipamentos, de compor caracteres tipograficos por outros processos, mesmo com dispositivo de fundir;1;UN
8082;84423090;Outras maquinas, aparelhos e material nao citados anteriormente;1;UN
8083;84424010;Partes de maquinas, aparelhos e equipamentos, de compor por processo fotografico;1;KG
8084;84424020;Partes de maquinas, aparelhos e equipamentos, de compor caracteres tipograficos por outros processos, mesmo com dispositivo de fundir;1;KG
8085;84424090;Partes de outras maquinas e aparelhos para preparacao/fabricacao de cliches;1;KG
8086;84425000;Cliches, blocos, cilindros e outros elementos de impressao, pedras litograficas, blocos, placas e cilindros, preparados para impressao (por exemplo, aplainados, granulados ou polidos);1;KG
8087;84431110;Maquinas e aparelhos de impressao, por ofsete, alimentados por bobinas, para impressao multicolor de jornais, de largura superior ou igual a 900 mm, com unidades de impressao em configuracao torre e dispositivos automaticos de emendar bobinas;1;UN
8088;84431190;Outras maquinas e aparelhos de impressao, por ofsete, alimentados por bobinas;1;UN
8089;84431200;Maquinas e aparelhos de impressao, por ofsete, dos tipos utilizados em escritorios, alimentados por folhas em que um lado nao seja superior a 22 cm e que o outro nao seja superior a 36 cm, quando nao dobradas;1;UN
8090;84431310;Maquinas e aparelhos de impressao, por ofsete, para impressao multicolor de recipientes de materias plasticas, cilindricos, conicos ou de faces planas;1;UN
8091;84431321;Maquinas e aparelhos de impressao, por ofsete, alimentados por folhas de formato inferior ou igual a 37,5 cm x 51 cm, com velocidade de impressao superior ou igual a 12.000 folhas por hora;1;UN
8092;84431329;Outras maquinas e aparelhos de impressao, por ofsete, alimentados por folhas de formato inferior ou igual a 37,5 cm x 51 cm;1;UN
8093;84431390;Outras maquinas/aparelhos de impressao por offset;1;UN
8094;84431400;Maquinas e aparelhos de impressao, tipograficos, alimentados por bobinas, excluindo as maquinas e aparelhos flexograficos;1;UN
8095;84431500;Maquinas e aparelhos de impressao, tipograficos, nao alimentados por bobinas, excluindo as maquinas e aparelhos flexograficos;1;UN
8096;84431600;Maquinas e aparelhos de impressao, flexograficos;1;UN
8097;84431710;Maquinas rotativas para heliogravura;1;UN
8098;84431790;Outras maquinas e aparelhos de impressao, heliograficos;1;UN
8099;84431910;Maquinas e aparelhos de impressao por meio de blocos, cilindros e outros elementos de impressao, para serigrafia;1;UN
8100;84431990;Outras maquinas e aparelhos de impressao por offset;1;UN
8101;84433111;Impressora de jato de tinta liquida, com largura de impressao inferior ou igual a 420 mm;1;UN
8102;84433112;Impressora de transferencia termica de cera solida (por exemplo, solid ink e dye sublimation);1;UN
8103;84433113;Impressora a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), monocromaticas, com largura de impressao inferior ou igual a 280 mm;1;UN
8104;84433114;Impressora a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), monocromaticas, com largura de impressao superior a 280 mm e inferior ou igual a 420 mm;1;UN
8105;84433115;Impressora a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), policromaticas;1;UN
8106;84433116;Outras impressoras com largura de impressao > 420 mm;1;UN
8107;84433119;Outras impressoras com capacidade de impressao <= 45 paginas por minuto;1;UN
8108;84433191;Outras impressoras com impressao para sistema termico;1;UN
8109;84433199;Outras impressoras multifuncionais;1;UN
8110;84433221;Impressoras de impacto, de linha;1;UN
8111;84433222;Impressoras de impacto, de caracteres braille;1;UN
8112;84433223;Impressoras de impacto, matriciais (por pontos);1;UN
8113;84433229;Outras impressoras de impacto;1;UN
8114;84433231;ImpressorasdDe jato de tinta liquida, com largura de impressao inferior ou igual a 420 mm;1;UN
8115;84433232;Impressoras de transferencia termica de cera solida (por exemplo, solid ink e dye sublimation);1;UN
8116;84433233;Impressoras a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), monocromaticas, com largura de impressao inferior ou igual a 280 mm;1;UN
8117;84433234;Impressora a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), monocromaticas, com largura de impressao superior a 280 mm e inferior ou igual a 420 mm;1;UN
8118;84433235;Impressoras a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), policromaticas, com velocidade de impressao inferior ou igual a 20 paginas por minuto (ppm);1;UN
8119;84433236;Impressoras a laser, LED (Diodos Emissores de Luz) ou LCS (Sistema de Cristal Liquido), policromaticas, com velocidade de impressao superior a 20 paginas por minuto (ppm);1;UN
8120;84433237;Termicas, dos tipos utilizados em impressao de imagens para diagnostico medico em folhas revestidas com camada termossensivel;1;UN
8121;84433238;Outras impressoras, com largura de impressao superior a 420 mm;1;UN
8122;84433239;Outras impressoras com velocidade de impressao < 30 paginas por minuto;1;UN
8123;84433240;Outras impressoras alimentadas por folhas;1;UN
8124;84433251;Tracadores graficos por meio de penas;1;UN
8125;84433252;Outras impressoras com largura de impressao > 580 mm;1;UN
8126;84433259;Outros tracadores graficos;1;UN
8127;84433291;Impressoras de codigo de barras postais, tipo 3 em 5, a jato de tinta fluorescente, com velocidade de ate 4,5 m/s e passo de 1,4 mm;1;UN
8128;84433299;Outras unidades de entrada e saida, para maquinas de processamento de dados;1;UN
8129;84433910;Maquinas de impressao por jato de tinta;1;UN
8130;84433921;Maquinas copiadoras eletrostaticas,de reproducao da imagem do original sobre a copia por meio de um suporte intermediario (processo indireto),monocromaticas,para copias de superficie inferior ou igual a 1 m2,com velocidade inferior a 100 copias por minuto;1;UN
8131;84433928;Outras maquinas copiadoras eletrostaticas, por processo indireto;1;UN
8132;84433929;Outras maquinas copiadoras eletrostaticas;1;UN
8133;84433930;Aparelhos de fotocopia, por sistema optico;1;UN
8134;84433990;Outras maquinas de impressao jato de tinta;1;UN
8135;84439110;Partes de maquinas e aparelhos da subposicao 8443.12 (Maquinas e aparelhos de impressao por offset, alimentados por folhas de formato <= 22x36 cm);1;KG
8136;84439191;Maquinas auxiliares de impressao, dobradoras;1;UN
8137;84439192;Numeradores automaticos;1;UN
8138;84439199;Outras maquinas auxiliares para impressao;1;UN
8139;84439911;Outros mecanismos de impressao, mesmo sem cabeca de impressao incorporada;1;UN
8140;84439912;Outros mecanismos de impressao, com cabeca de impressao;1;UN
8141;84439919;Outros mecanismos de impressao por impacto;1;KG
8142;84439921;Outros mecanismos de impressao por jato de tinta, mesmo sem cabeca incorporada;1;UN
8143;84439922;Outras cabecas de impressao para mecanismos de impressao por jato de tinta;1;UN
8144;84439923;Outros cartuchos de tinta;1;KG
8145;84439929;Outras partes/acessorios de impressao tracadores graficos;1;KG
8146;84439931;Mecanismos de impressao, mesmo sem cilindro fotossensivel incorporado;1;KG
8147;84439932;Cilindros recobertos de materia semicondutora fotoeletrica;1;KG
8148;84439933;Cartuchos de revelador (toners);1;KG
8149;84439939;Outras partes e acessorios para aparelhos de fotocopia eletrostatico;1;KG
8150;84439941;Outros mecanismos de impressao, mesmo sem cabeca de impressao incorporada;1;KG
8151;84439942;Outras cabecas de impressao;1;KG
8152;84439949;Outros mecanismos de impressao a laser, led, lcs, partes e acessorios;1;KG
8153;84439950;Outros mecanismos de impressao, suas partes e acessorios;1;KG
8154;84439960;Circuitos impressos com componentes eletricos ou eletronicos, montados;1;KG
8155;84439970;Outras bandejas e gavetas, suas partes e acessorios;1;KG
8156;84439980;Mecanismos de alimentacao ou de triagem de papeis ou documentos, suas partes e acessorios;1;KG
8157;84439990;Outras partes e acessorios para impressao;1;KG
8158;84440010;Maquinas para extrudar materias texteis sinteticas ou artificiais;1;UN
8159;84440020;Maquinas para corte ou ruptura de fibras texteis sinteticas ou artificiais;1;UN
8160;84440090;Outras maquinas para estirar ou texturizar materias texteis sinteticas ou artificiais.;1;UN
8161;84451110;Cardas para la;1;UN
8162;84451120;Cardas para fibras do Capitulo 53;1;UN
8163;84451190;Cardas para preparacao de outras materias texteis;1;UN
8164;84451200;Penteadoras de materias texteis;1;UN
8165;84451300;Bancas de estiramento (bancas de fusos), de materias texteis;1;UN
8166;84451910;Maquinas para preparacao da seda;1;UN
8167;84451921;Maquinas para recuperacao de cordas, fios, trapos ou qualquer outro desperdicio, transformando-os em fibras adequadas para cardagem;1;UN
8168;84451922;Descarocadeiras e deslintadeiras de algodao;1;UN
8169;84451923;Maquinas para desengordurar, lavar, alvejar ou tingir fibras texteis em massa ou rama;1;UN
8170;84451924;Abridoras de fibras de la;1;UN
8171;84451925;Abridoras de outras fibras texteis vegetais;1;UN
8172;84451926;Maquinas de carbonizar a la;1;UN
8173;84451927;Maquinas para estirar a la;1;UN
8174;84451929;Outras maquinas para preparacao de materia textil;1;UN
8175;84452000;Maquinas para fiacao de materias texteis;1;UN
8176;84453010;Retorcedeiras de materias texteis;1;UN
8177;84453090;Outras maquinas para dobragem ou torcao, de materias texteis;1;UN
8178;84454011;Bobinadeiras de trama (espuladeiras), automaticas, de materias texteis;1;UN
8179;84454012;Bobinadeiras automaticas para fios elastanos;1;UN
8180;84454018;Outras bobinadeiras de materias texteis, com atador automatico;1;UN
8181;84454019;Outras bobinadeiras de materias texteis, automatica;1;UN
8182;84454021;Bobinadoras nao automaticas, de materias texteis, com velocidade de bobinado superior ou igual a 4.000 m/min;1;UN
8183;84454029;Outras bobinadeiras de materias texteis, nao automaticas;1;UN
8184;84454031;Meadeiras com controle de comprimento ou peso e atador automatico, de materias texteis,;1;UN
8185;84454039;Outras meadeiras de materias texteis;1;UN
8186;84454040;Noveleiras automaticas, de materias texteis;1;UN
8187;84454090;Outras maquinas de bobinar ou de dobar, materia textil;1;UN
8188;84459010;Urdideiras de materia textil;1;UN
8189;84459020;Passadeiras para lico e pente, de materia textil;1;UN
8190;84459030;Maquinas para amarrar urdideiras de materia textil;1;UN
8191;84459040;Maquinas para colocar lamelas de materia textil, automaticas;1;UN
8192;84459090;Outras maquinas e aparelhos para fabricacao/preparacao de fios texteis;1;UN
8193;84461010;Teares para tecidos de largura nao superior a 30 cm, com mecanismo Jacquard;1;UN
8194;84461090;Outros teares para tecidos de largura nao superior a 30 cm;1;UN
8195;84462100;Teares para tecidos de largura superior a 30 cm, de lancadeiras, a motor;1;UN
8196;84462900;Outros teares para tecidos de largura superior a 30 cm, de lancadeira;1;UN
8197;84463010;Teares para tecidos de largura superior a 30 cm, sem lancadeira, a jato de ar;1;UN
8198;84463020;Teares para tecidos de largura superior a 30 cm, sem lancadeira, a jato dagua;1;UN
8199;84463030;Teares para tecidos de largura superior a 30 cm, sem lancadeira, de projetil;1;UN
8200;84463040;Teares para tecidos de largura superior a 30 cm, sem lancadeira, de pincas;1;UN
8201;84463090;Outros teares para tecidos de largura superior a 30 cm, sem lancadeira;1;UN
8202;84471100;Teares circulares para malhas, com cilindro de diametro nao superior a 165 mm;1;UN
8203;84471200;Teares circulares para malhas, com cilindro de diametro superior a 165 mm;1;UN
8204;84472010;Teares retilineos, para malhas, manuais;1;UN
8205;84472021;Teares retilineos, motorizados, para fabricacao de malhas de urdidura;1;UN
8206;84472029;Outros teares retilineos, motorizados, para malhas;1;UN
8207;84472030;Maquinas de costura por entrelacamento (couture-tricotage);1;UN
8208;84479010;Maquinas para fabricacao de redes, tules ou filos;1;UN
8209;84479020;Maquinas automaticas para bordar;1;UN
8210;84479090;Outras maquinas para fabricar guipuras, tules, rendas, bordados, passamanarias, galoes ou redes e maquinas para inserir tufos;1;UN
8211;84481110;Ratieras para teares;1;UN
8212;84481120;Mecanismos Jacquard para teares;1;UN
8213;84481190;Redutores, perfuradores e copiadores de cartoes, etc.;1;UN
8214;84481900;Outras maquinas e aparelhos auxiliares para trabalhar, etc, materia textil;1;UN
8215;84482010;Fieiras para a extrusao de materia textil sintetica/artificial;1;UN
8216;84482020;Outras partes e acessorios de maquinas para extrusao de materia textil;1;KG
8217;84482030;Partes e acessorios de maquinas para corte ou ruptura de fibra textil;1;KG
8218;84482090;Outras partes e acessorios de maquinas para estirar, etc, materia textil;1;KG
8219;84483100;Guarnicoes de cardas;1;UN
8220;84483211;Chapeus (flats) de cardas;1;UN
8221;84483219;Outras partes e acessorios de cardas;1;KG
8222;84483220;Partes e acessorios de penteadoras de materia textil;1;KG
8223;84483230;Bancas de estiramento de materia textil;1;UN
8224;84483240;Partes e acessorios de maquinas para preparacao da seda;1;KG
8225;84483250;Partes e acessorios de maquinas para carbonizar la;1;KG
8226;84483290;Outras partes e acessorios de maquinas para preparacao de materia textil;1;KG
8227;84483310;Cursores de fusos para maquinas de preparacao de materia textil;1;UN
8228;84483390;Fusos, suas aletas e aneis, para maquinas de preparacao de materia textil;1;KG
8229;84483911;Partes e acessorios de maquinas de filatorios intermitentes (selfatinas), para preparacao de materias texteis;1;KG
8230;84483912;Partes e acessorios de maquinas do tipo tow-to-yarn, para preparacao de materias texteis;1;KG
8231;84483917;Partes e acessorios de outros filatorios, para preparacao de materias texteis;1;KG
8232;84483919;Partes e acessorios de maquinas para dobragem, e torcao de materia textil;1;KG
8233;84483921;Partes e acessorios de bobinadeiras de trama;1;KG
8234;84483922;Partes e acessorios de bobinadeiras automaticas para fios elastanos;1;KG
8235;84483923;Partes e acessorios de outras bobinadeiras automaticas;1;KG
8236;84483929;Partes e acessorios de outras maquinas de bobinar ou de dobar;1;KG
8237;84483991;Partes e acessorios de urdideiras;1;KG
8238;84483992;Partes e acessorios de passadeiras para lico e pente;1;KG
8239;84483999;Partes e acessorios de outras maquinas e aparelhos para trabalhar materia textil;1;KG
8240;84484200;Pentes, licos e quadros de licos, de teares para tecidos;1;UN
8241;84484910;Partes e acessorios de maquinas e aparelhos auxiliares de teares;1;KG
8242;84484920;Partes e acessorios de teares para tecidos de largura superior a 30 cm, sem lancadeiras, a jato de agua ou de projetil;1;KG
8243;84484990;Outras partes e acessorios de teares para tecidos;1;KG
8244;84485100;Platinas, agulhas e outros artigos, utilizados na formacao das malhas;1;KG
8245;84485910;Partes e acessorios de teares circulares, para fabricacao de malhas;1;KG
8246;84485921;Partes e acessorios de teares retilineos manuais, para fabricacao de malhas;1;KG
8247;84485922;Partes e acessorios de teares retilineos para fabricacao de malhas por urdidura;1;KG
8248;84485929;Outras partes e acessorios de outros teares retilineos;1;KG
8249;84485930;Partes e acessorios de maquinas para fabricacao de redes, tules, filos, etc.;1;KG
8250;84485940;Partes e acessorios de maquinas para fabricar guipuras, rendas, etc.;1;KG
8251;84485990;Outras partes e acessorios de outros teares, maquinas de costura entrelacado;1;KG
8252;84490010;Maquinas e aparelhos para fabricacao/acabamento de feltros;1;UN
8253;84490020;Maquinas e aparelhos para fabricar falsos tecidos;1;UN
8254;84490080;Outras maquinas e aparelhos para fabricacao e acabamento de chapeus de feltro;1;UN
8255;84490091;Partes de maquinas e aparelhos para fabricacao de falsos tecidos;1;KG
8256;84490099;Partes de maquinas e aparelhos para fabricacao e acabamento de feltros, etc;1;KG
8257;84501100;Maquinas de lavar roupa, de capacidade, expressa em peso de roupa seca, nao superior a 10 kg, inteiramente automatica;1;UN
8258;84501200;Maquinas de lavar roupa, de capacidade, expressa em peso de roupa seca, nao superior a 10 kg, com secadora centrifuga incorporada;1;UN
8259;84501900;Outras maquinas de lavar roupa, de capacidade, expressa em peso de roupa seca, nao superior a 10 kg;1;UN
8260;84502010;Tuneis continuos de lavar roupa, de capacidade, expressa em peso de roupa seca, superior a 10 kg;1;UN
8261;84502090;Outras maquinas de lavar roupa, de capacidade, expressa em peso de roupa seca, superior a 10 kg;1;UN
8262;84509010;Partes de maquinas de lavar roupa, de capacidade, expressa em peso de roupa seca, superior a 10 kg;1;KG
8263;84509090;Partes de maquinas de lavar roupa, capacidade <= 10 kg de roupa seca;1;KG
8264;84511000;Maquinas para lavar roupa, a seco;1;UN
8265;84512100;Maquinas para secar roupa, de capacidade, expressa em peso de roupa seca, nao superior a 10 kg;1;UN
8266;84512910;Outras maquinas para secar roupa, que funcionem por meio de ondas eletromagneticas (micro-ondas), cuja producao seja superior ou igual a 120 kg/h de produto seco;1;UN
8267;84512990;Outras maquinas para secar roupa;1;UN
8268;84513010;Maquinas e prensas para passar roupa, automaticas;1;UN
8269;84513091;Prensas para passar roupa, de peso inferior ou igual a 14 kg;1;UN
8270;84513099;Outras maquinas e prensas para passar roupa, inclusive as fixadoras;1;UN
8271;84514010;Maquinas para lavar fios, tecidos, obras de materias texteis;1;UN
8272;84514021;Maquinas para tingir tecidos em rolos, por pressao estatica, etc;1;UN
8273;84514029;Outras maquinas para tingir ou branquear fios ou tecidos;1;UN
8274;84514090;Maquinas para branquear ou tingir outras materias texteis;1;UN
8275;84515010;Maquinas para inspecionar tecidos;1;UN
8276;84515020;Maquinas automaticas para enfestar ou cortar tecidos;1;UN
8277;84515090;Outras maquinas para enrolar, desenrolar, dobrar e dentear tecidos;1;UN
8278;84518000;Outras maquinas e aparelhos para trabalhar materias texteis;1;UN
8279;84519010;Partes de maquinas de secar, capacidade <=10 kg de roupa seca;1;KG
8280;84519090;Partes de outras maquinas e aparelhos para trabalhar material textil;1;KG
8281;84521000;Maquinas de costura de uso domestico;1;UN
8282;84522110;Maquinas para costurar couros ou peles, automaticas;1;UN
8283;84522120;Maquinas para costurar tecidos, automaticas;1;UN
8284;84522190;Maquinas para costurar outras materias, automaticas;1;UN
8285;84522910;Maquinas para costurar couros ou peles, nao automaticas;1;UN
8286;84522921;Remalhadeiras para costurar tecidos, nao automaticas;1;UN
8287;84522922;Maquinas para casear tecidos, nao automaticas;1;UN
8288;84522923;Maquinas tipo zigue-zague para inserir elastico, nao automatica;1;UN
8289;84522924;Maquinas para costurar tecido, de costura reta, nao automatica;1;UN
8290;84522925;Maquinas para costurar tecidos, galoneiras, nao automaticas;1;UN
8291;84522929;Outras maquinas para costurar tecidos, nao automaticas;1;UN
8292;84522990;Outras maquinas de costura, nao automaticas;1;UN
8293;84523000;Agulhas para maquinas de costura;1;KG
8294;84529020;Moveis, bases e tampas, para maquinas de costura, suas partes;1;KG
8295;84529081;Guia-fios, lancadeiras e porta-bobinas para maquina de costura;1;KG
8296;84529089;Outras partes de maquinas de costura de uso domestico;1;KG
8297;84529091;Guia-fios, lancadeiras nao rotativas e porta-bobinas para outras maquinas de costura;1;KG
8298;84529092;Partes para remalhadeiras;1;KG
8299;84529093;Lancadeiras rotativas de maquinas de costurar;1;UN
8300;84529094;Corpos moldados por fundicao;1;UN
8301;84529099;Partes de outras maquinas de costurar;1;KG
8302;84531010;Maquinas para dividir couros com largura util inferior ou igual a 3.000 mm, com lamina sem fim, com controle eletronico programavel;1;UN
8303;84531090;Outras maquinas e aparelhos para preparacao, curtimenta e trabalho em couros e peles;1;UN
8304;84532000;Maquinas e aparelhos para fabricar ou consertar calcados;1;UN
8305;84538000;Maquinas e aparelhos para fabricar ou consertar outras obras de couro ou de pele;1;UN
8306;84539000;Partes de maquinas e aparelhos para preparar, curtir ou trabalhar couros ou peles;1;KG
8307;84541000;Conversores para metalurgia, aciaria ou fundicao;1;UN
8308;84542010;Lingoteiras de fundicao;1;UN
8309;84542090;Cadinhos ou colheres de fundicao;1;UN
8310;84543010;Maquinas de vazar (moldar) sob pressao;1;UN
8311;84543020;Maquinas de vazar (moldar) por centrifugacao;1;UN
8312;84543090;Outras maquinas de vazar (moldar), para metalurgia, aciaria ou fundicao;1;UN
8313;84549010;Partes de maquinas de vazar (moldar) por centrifugacao;1;KG
8314;84549090;Partes de conversores, etc, para metalurgia, aciaria ou fundicao;1;KG
8315;84551000;Laminadores de tubos, de metais;1;UN
8316;84552110;Laminadores a quente e laminadores combinados a quente e a frio, de cilindros lisos, de metais;1;UN
8317;84552190;Outros laminadores a quente e/ou frio, de metais;1;UN
8318;84552210;Laminadores a frio, de cilindro liso, de metais;1;UN
8319;84552290;Outros laminadores a frio de metais;1;UN
8320;84553010;Cilindros de laminadores, fundidos, de aco ou ferro fundido nodular;1;UN
8321;84553020;Cilindros de laminadores, forjados, de aco de corte rapido, com um teor, em peso, de carbono >= 0,80 % e <= 0,90 %, de cromo >= 3,50 % e <=4 %, de vanadio >= 1,60 % e <= 2,30 %, de molibdenio <= 8,50 % e de tungstenio (volframio) inferior ou igual a 7 %;1;UN
8322;84553090;Outros cilindros de laminadores de metais;1;UN
8323;84559000;Outras partes de laminadores de metais;1;KG
8324;84561111;Maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por laser, de comando numerico, para corte de chapas metalicas de espessura superior a 8 mm;1;UN
8325;84561119;Maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por laser, de comando numerico, para corte de outras chapas;1;UN
8326;84561190;Outras maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por laser;1;UN
8327;84561211;Maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por outro feixe de luz ou de fotons, de comando numerico, para corte de chapas metalicas de espessura superior a 8 mm;1;UN
8328;84561219;Maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por outro feixe de luz ou de fotons, de comando numerico, para corte de outras chapas;1;UN
8329;84561290;Outras maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por outro feixe de luz ou de fotons;1;UN
8330;84562010;Maquinas-ferramentas que operem por ultrassom, de comando numerico;1;UN
8331;84562090;Outras maquinas-ferramentas que operem por ultrassom;1;UN
8332;84563011;Maquinas-ferramentas que operem por eletroerosao, de comando numerico, para texturizar superficies cilindricas;1;UN
8333;84563019;Outras maquinas-ferramentas que operem por eletroerosao, de comando numerico;1;UN
8334;84563090;Outras maquinas-ferramentas operadas por eletroerosao;1;UN
8335;84564000;Maquinas-ferramentas que trabalhem por eliminacao de qualquer materia, que operem por jato de plasma;1;UN
8336;84565000;Maquinas de corte a jato de agua;1;UN
8337;84569000;Outras maquinas-ferramentas que trabalhem por eliminacao de qualquer materia;1;UN
8338;84571000;Centros de usinagem, para trabalhar metais;1;UN
8339;84572010;Maquinas de sistema monostatico (single station), de comando numerico, para trabalhar metais;1;UN
8340;84572090;Outras maquinas de sistema monostatico, para trabalhar metais;1;UN
8341;84573010;Maquinas de estacoes multiplas, de comando numerico, para trabalhar metais;1;UN
8342;84573090;Outras maquinas de estacoes multiplas, para trabalhar metais;1;UN
8343;84581110;Tornos horizontais para trabalhar metais, com comando numerico tipo revolver;1;UN
8344;84581191;Tornos horizontais para trabalhar metais, de 6 ou mais fusos porta-pecas;1;UN
8345;84581199;Outros tornos horizontais para trabalhar metais, de comando numerico;1;UN
8346;84581910;Tornos horizontais para trabalhar metais, sem comando numerico, tipo revolver;1;UN
8347;84581990;Outros tornos horizontais para trabalhar metais, sem comando numerico;1;UN
8348;84589100;Outros tornos para trabalhar metais, de comando numerico;1;UN
8349;84589900;Outros tornos para trabalhar metais, sem comando numerico;1;UN
8350;84591000;Maquinas-ferramentas para furar, mandrilar, fresar, roscar interior ou exteriormente metais, unidades com cabeca deslizante;1;UN
8351;84592110;Maquinas-ferramentas para furar, mandrilar, fresar, roscar interior ou exteriormente metais, de comando numerico, radiais;1;UN
8352;84592191;Maquinas-ferramentas para furar, mandrilar, fresar, roscar interior ou exteriormente metais, de comando numerico, de mais de um cabecote mono ou multifuso;1;UN
8353;84592199;Outras maquinas-ferramentas para furar metais, de comando numerico;1;UN
8354;84592900;Outras maquinas-ferramentas para furar metais;1;UN
8355;84593100;Outras mandriladoras-fresadoras de metais, de comando numerico;1;UN
8356;84593900;Outras mandriladoras-fresadoras de metais, sem comando numerico;1;UN
8357;84594100;Outras maquinas para mandrilar (escarear), de comando numerico;1;UN
8358;84594900;Outras maquinas para mandrilar (escarear);1;UN
8359;84595100;Maquinas-ferramentas para fresar metais, com console, de comando numerico;1;UN
8360;84595900;Maquinas-ferramentas para fresar metais, com console, sem comando numerico;1;UN
8361;84596100;Outras maquinas-ferramentas para fresar metais, sem console, de comando numerico;1;UN
8362;84596900;Maquinas-ferramentas para fresar metais, sem console, sem comando numerico;1;UN
8363;84597000;Outras maquinas para roscar interior ou exteriormente o metal;1;UN
8364;84601200;Maquinas para retificar superficies planas, de comando numerico;1;UN
8365;84601900;Outras maquinas para retificar superficies planas, cujo posicionamento sobre qualquer dos eixos pode ser estabelecido com precisao de pelo menos 0,01 mm;1;UN
8366;84602200;Maquinas para retificar sem centro, de comando numerico;1;UN
8367;84602300;Outras maquinas para retificar superficies cilindricas, de comando numerico;1;UN
8368;84602400;Outras maquinas para retificar, de comando numerico;1;UN
8369;84602900;Outras maquinas para retificar, cujo posicionamento sobre qualquer dos eixos pode ser estabelecido com precisao de pelo menos 0,01 mm;1;UN
8370;84603100;Maquinas-ferramentas para afiar metais/ceramais, de comando numerico;1;UN
8371;84603900;Outras maquinas-ferramentas para afiar metais/ceramais;1;UN
8372;84604011;Brunidoras para cilindros de diametro inferior ou igual a 312 mm, de comando numerico;1;UN
8373;84604019;Outras maquinas-ferramentas para brunir metais/ceramais, de comando numerico;1;UN
8374;84604091;Outras brunidoras para cilindros de diametro inferior ou igual a 312 mm;1;UN
8375;84604099;Outras maquinas-ferramentas para brunir metais/ceramais;1;UN
8376;84609011;Maquinas-ferramentas de polir, com cinco ou mais cabecas e porta-pecas rotativo, metais/ceramais, de comando numerico;1;UN
8377;84609012;Maquinas-ferramentas de esmerilhar, com duas ou mais cabecas e porta-pecas rotativo, de comando numerico;1;UN
8378;84609019;Outras maquinas-ferramentas para amolar, etc, metais/ceramais, de comando numerico;1;UN
8379;84609090;Outras maquinas-ferramentas para amolar, etc, metais/ceramais;1;UN
8380;84612010;Maquinas-ferramentas para escatelar engrenagens;1;UN
8381;84612090;Plainas-limadoras de engrenagens;1;UN
8382;84613010;Maquinas-ferramentas para brochar engrenagens, de comando numerico;1;UN
8383;84613090;Outras maquinas-ferramentas para brochar engrenagens;1;UN
8384;84614010;Maquinas para cortar ou acabar engrenagens, com comando numerico;1;UN
8385;84614091;Redondeadoras de dentes de engrenagens;1;UN
8386;84614099;Outras maquinas-ferramentas para cortar/acabar engrenagens;1;UN
8387;84615010;Maquinas-ferramentas para serrar ou seccionar metais, de fitas sem fim;1;UN
8388;84615020;Maquinas-ferramentas para serrar ou seccionar metais, circulares;1;UN
8389;84615090;Outras maquinas-ferramentas para serrar ou seccionar metais;1;UN
8390;84619010;Outras maquinas-ferramentas que trabalhem por eliminacao de metal ou de ceramais (cermets), nao especificadas nem compreendidas noutras posicoes, de comando numerico;1;UN
8391;84619090;Outras maquinas-ferramentas que trabalhem por eliminacao de metal ou de ceramais (cermets), nao especificadas nem compreendidas noutras posicoes;1;UN
8392;84621011;Maquinas-ferramentas para estampar metais, de comando numerico;1;UN
8393;84621019;Maquinas (incluindo as prensas) para forjar martelos, martelos-piloes e martinetes, de comando numerico;1;UN
8394;84621090;Outras maquinas (incluindo as prensas) para forjar martelos, martelos-piloes e martinetes;1;UN
8395;84622100;Maquinas (incluindo as prensas) para enrolar, arquear, dobrar, endireitar ou aplanar metais, de comando numerico;1;UN
8396;84622900;Outras maquinas-ferramentas (incluindo as prensas) para enrolar, arquear, dobrar, endireitar ou aplanar metais;1;UN
8397;84623100;Maquinas-ferramentas para cisalhar metais, de comando numerico;1;UN
8398;84623910;Maquinas-ferramentas para cisalhar metais, tipo guilhotina;1;UN
8399;84623990;Outras maquinas-ferramentas para cisalhar metais;1;UN
8400;84624100;Maquinas (incluindo as prensas) para puncionar ou para chanfrar metais, incluindo as maquinas combinadas de puncionar e cisalhar, de comando numerico;1;UN
8401;84624900;Maquinas (incluindo as prensas) para puncionar ou para chanfrar metais, incluindo as maquinas combinadas de puncionar e cisalhar;1;UN
8402;84629111;Prensas hidraulicas, de capacidade igual ou inferior a 35.000 kN, para moldagem de pos metalicos por sinterizacao;1;UN
8403;84629119;Outras prensas hidraulicas, de capacidade igual ou inferior a 35.000 kN;1;UN
8404;84629191;Outras prensas hidraulicas para moldagem de pos metalicos por sinterizacao;1;UN
8405;84629199;Outras prensas hidraulicas para metais/carbonetos metalicos;1;UN
8406;84629910;Prensas para moldagem de pos metalicos por sinterizacao;1;UN
8407;84629920;Prensas para extrusao de metais/carbonetos metalicos;1;UN
8408;84629990;Outras prensas para trabalhar metais/carbonetos metalicos;1;UN
8409;84631010;Bancas para estirar tubos de metais ou ceramais (cermets);1;UN
8410;84631090;Bancas para estirar barras, perfis, fios ou semelhantes, de metais ou ceramais (cermets);1;UN
8411;84632010;Maquinas para fazer roscas internas ou externas por laminagem, de comando numerico;1;UN
8412;84632091;Outras maquinas-ferramentas de pente plano, com capacidade de producao superior ou igual a 160 unidades por minuto, de diametro de rosca compreendido entre 3 mm e 10 mm;1;UN
8413;84632099;Outras maquinas-ferramentas para fazer roscas por laminagem de metais, etc;1;UN
8414;84633000;Maquinas para trabalhar arames e fios de metal;1;UN
8415;84639010;Outras maquinas-ferramentas para trabalhar metais ou ceramais (cermets), que trabalhem sem eliminacao de materia, de comando numerico;1;UN
8416;84639090;Outras maquinas-ferramentas para trabalhar metais ou ceramais (cermets), que trabalhem sem eliminacao de materia;1;UN
8417;84641000;Maquinas-ferramentas para serrar pedra, produtos ceramicos, concreto, fibrocimento ou materias minerais semelhantes, ou para o trabalho a frio do vidro;1;UN
8418;84642010;Maquinas para esmerilar ou polir, para vidro;1;UN
8419;84642021;Maquinas-ferramentas para ceramica, de polir placas, para pavimentacao ou revestimento, com oito ou mais cabecas;1;UN
8420;84642029;Outras maquinas-ferramentas para esmerilar ou polir ceramica;1;UN
8421;84642090;Maquinas-ferramentas para esmerilar/polir pedra, etc.;1;UN
8422;84649011;Outras maquinas-ferramentas, de comando numerico, para retificar, fresar e perfurar vidro;1;UN
8423;84649019;Outras maquinas-ferramentas para trabalho a frio do vidro;1;UN
8424;84649090;Outras-maquinas ferramentas para trabalhar pedra, produtos ceramicos, concreto, fibrocimento ou materias minerais semelhantes, ou para o trabalho a frio do vidro.;1;UN
8425;84651000;Maquinas-ferramentas capazes de efetuar diferentes tipos de operacoes sem troca de ferramentas, para trabalhar madeira, cortica, osso, borracha endurecida, plasticos duros ou materias duras semelhantes;1;UN
8426;84652000;Centros de usinagem (fabricacao);1;UN
8427;84659110;Maquinas-ferramentas de serrar madeira, cortica, osso, borracha endurecida, plasticos duros ou materias duras semelhantes, de fita sem fim;1;UN
8428;84659120;Maquinas-ferramentas de serrar madeira, cortica, osso, borracha endurecida, plasticos duros ou materias duras semelhantes, circulares;1;UN
8429;84659190;Outras maquinas-ferramentas de serrar madeira, cortica, osso, etc;1;UN
8430;84659211;Fresadoras de madeira, cortica, osso, borracha endurecida, plasticos duros ou materias duras semelhantes, de comando numerico;1;UN
8431;84659219;Maquinas-ferramentas para desbastar, etc, madeira, cortica, etc, de comando numerico;1;UN
8432;84659290;Outras maquinas-ferramentas para desbastar, etc, madeira, cortica, etc;1;UN
8433;84659310;Lixadeiras para madeira, cortica, osso, borracha endurecida, plasticos duros ou materias duras semelhantes;1;UN
8434;84659390;Outras maquinas-ferramentas para esmerilar/polir madeira, cortica, etc.;1;UN
8435;84659400;Maquinas-ferramentas para arquear/reunir madeira, cortica, osso, etc.;1;UN
8436;84659511;Maquinas para furar madeira, cortica, etc, de comando numerico;1;UN
8437;84659512;Maquinas para escatelar madeira, cortica, etc, de comando numerico;1;UN
8438;84659591;Outras maquinas-ferramentas para furar madeira, cortica, osso, etc.;1;UN
8439;84659592;Outras maquinas-ferramentas para escatelar madeira, cortica, osso, etc.;1;UN
8440;84659600;Maquinas para fender, seccionar ou desenrolar madeira, etc.;1;UN
8441;84659900;Outras maquinas-ferramentas para trabalhar madeira, cortica, osso, etc.;1;UN
8442;84661000;Porta-ferramentas e fieiras de abertura automatica;1;KG
8443;84662010;Porta-pecas para tornos;1;KG
8444;84662090;Porta-pecas para outras maquinas-ferramentas;1;KG
8445;84663000;Dispositivos divisores e outros dispositivos especiais, para maquinas-ferramentas;1;KG
8446;84669100;Partes e acessorios de maquinas-ferramentas para trabalhar pedra, concreto, etc (posicao 84.64);1;KG
8447;84669200;Partes e acessorios de maquinas-ferramentas para trabalhar madeira, osso, etc. (posicao 84.65);1;KG
8448;84669311;Partes e acessorios de maquinas-ferramentas operadas por ultra-som (subposicao 8456.20);1;KG
8449;84669319;Partes e acessorios de maquinas-ferramentas operadas por laser, etc.;1;KG
8450;84669320;Partes e acessorios de centros de usinagem, etc, para trabalhar metais (maquinas da posicao 84.57);1;KG
8451;84669330;Partes e acessorios de tornos para metais (maquinas da posicao 84.58);1;KG
8452;84669340;Partes e acessorios de maquinas-ferramentas para furar, fresar, etc, metais (maquinas da posicao 84.59);1;KG
8453;84669350;Partes e acessorios de maquinas-ferramentas para afiar, amolar, etc, metais (maquinas da posicao 84.60);1;KG
8454;84669360;Partes e acessorios de maquinas-ferramentas para aplainar, etc, engrenagem (maquinas da posicao 84.61);1;KG
8455;84669410;Partes e acessorios de maquinas-ferramentas para forjar, etc, metais (maquinas da subposicao 8462.10);1;KG
8456;84669420;Partes e acessorios de maquinas-ferramentas para enrolar, etc, metais (maquinas das subposicoes 8462.21 ou 8462.29);1;KG
8457;84669430;Partes e acessorios de prensas para extrusao de metais;1;KG
8458;84669490;Partes e acessorios de outras maquinas-ferramentas para trabalhar metais, etc;1;KG
8459;84671110;Furadeiras pneumaticas rotativas, de uso manual;1;UN
8460;84671190;Outras ferramentas pneumaticas rotativas, de uso manual;1;UN
8461;84671900;Outras ferramentas pneumaticas, de uso manual;1;UN
8462;84672100;Furadeiras com motor eletrico incorporado;1;UN
8463;84672200;Serras com motor eletrico incorporado;1;UN
8464;84672910;Tesouras com motor eletrico incorporado;1;UN
8465;84672991;Cortadoras de tecidos, com motor eletrico incorporado;1;UN
8466;84672992;Parafusadeiras e rosqueadeiras, com motor eletrico;1;UN
8467;84672993;Martelos com motor eletrico incorporado;1;UN
8468;84672999;Outras ferramentas com motor eletrico incorporado;1;UN
8469;84678100;Serras de corrente, de uso manual;1;UN
8470;84678900;Outras ferramentas hidraulicas de motor nao eletrico, de uso manual;1;UN
8471;84679100;Partes de serras de corrente, de uso manual;1;KG
8472;84679200;Partes de ferramentas pneumaticas, de uso manual;1;KG
8473;84679900;Partes de ferramentas hidraulicas, de motor nao eletrico, manuais;1;KG
8474;84681000;Macaricos de uso manual;1;UN
8475;84682000;Outras maquinas e aparelhos a gas, para tempera superficial;1;UN
8476;84688010;Maquinas e aparelhos para soldar por friccao;1;UN
8477;84688090;Outras maquinas e aparelhos para soldar;1;UN
8478;84689010;Partes de macaricos de uso manual;1;KG
8479;84689020;Partes de maquinas e aparelhos para soldar por friccao;1;KG
8480;84689090;Partes de outras maquinas e aparelhos para soldar, maquinas e aparelhos a gas;1;KG
8481;84701000;Calculadoras eletronicas capazes de funcionar sem fonte externa de energia eletrica e maquinas de bolso com funcao de calculo incorporada que permitam gravar, reproduzir e visualizar informacoes;1;UN
8482;84702100;Maquinas de calcular, eletronica, com dispositivo de impressao incorporado;1;UN
8483;84702900;Outras maquinas de calcular, eletronicas;1;UN
8484;84703000;Outras maquinas de calcular;1;UN
8485;84705011;Caixas registradoras, eletronicas, com capacidade de comunicacao com computador, etc;1;UN
8486;84705019;Outras caixas registradoras eletronicas;1;UN
8487;84705090;Outras caixas registradoras;1;UN
8488;84709010;Maquinas de franquear correspondencia;1;UN
8489;84709090;Outras maquinas de franquear, emitir tiquetes e maquinas semelhantes;1;UN
8490;84713011;Maquinas digitais de processamento de dados, bateria/eletrica, portateis, peso < 350 g, tamanho <= 140 cm2;1;UN
8491;84713012;Maquinas digitais de processamento de dados, bateria/eletrica, portateis, peso < 3,5 kg, tamanho <= 560 cm2;1;UN
8492;84713019;Outras maquinas digitais para processamento de dados, bateria/eletrica, portateis, peso <= 10 kg;1;UN
8493;84713090;Outras maquinas automaticas digitais para processamento de dados, portateis, peso <= 10 kg, etc;1;UN
8494;84714110;Maquinas digitais de processamento de dados, de peso inferior a 750 g, sem teclado, com reconhecimento de escrita, entrada de dados e de comandos por meio de uma tela de area inferior a 280 cm2;1;UN
8495;84714190;Outras maquinas digitais para processamento de dados, com ucp, mesmo com unidade de entrada e saida;1;UN
8496;84714900;Outras maquinas automaticas de processamento de dados sob forma de sistemas;1;UN
8497;84715010;Unidade de processamento digital de pequena capacidade,baseadas em microprocessadores,com capacidade de instalacao,dentro do mesmo gabinete,de unidades de memoria da subposicao 8471.70,podendo conter multiplos slots, FOB <= US$ 12.500 por unidade;1;UN
8498;84715020;Unidade de processamento digital de media capacidade,maximo de 1 unidade de entrada e 1 de saida da subposicao 8471.60,com capacidade de instalacao,no mesmo gabinete,de memorias 8471.70, podendo conter multiplos slots,valor FOB > US$ 12.500  <= US$ 46.000;1;UN
8499;84715030;Unidade de processamento digital de grande capacidade, maximo 1 unidade de entrada e 1 de saida da subposicao 8471.60, com capacidade de instalacao interna, de unidades de memoria da subposicao 8471.70, FOB > US$ 46.000 e <= US$ 100.000;1;UN
8500;84715040;Unidade de processamento digital de muito grande capacidade, 1 unidade de entrada e 1 de saida da subposicao 8471.60, de unidades de memoria da subposicao 8471.70, valor FOB > US$ 100.000 por unidade;1;UN
8501;84715090;Outras unidades de processamento, exceto as das subposicoes 8471.41 ou 8471.49, podendo conter, no mesmo corpo, um ou dois dos seguintes tipos de unidades: unidade de memoria, unidade de entrada e unidade de saida;1;UN
8502;84716052;Teclados para maquinas automaticas de processamento de dados;1;UN
8503;84716053;Indicadores ou apontadores (mouse e track-ball, por exemplo), para maquinas automaticas de processamento de dados;1;UN
8504;84716054;Mesas digitalizadoras, para maquinas automaticas de processamento de dados;1;UN
8505;84716059;Outras unidades de entrada, para maquinas automaticas de processamento de dados;1;UN
8506;84716061;Aparelhos terminais com teclado alfanumerico video monocromatico;1;UN
8507;84716062;Aparelhos terminais com teclado alfanumerico video policromatico;1;UN
8508;84716080;Terminais de auto-atendimento bancario;1;UN
8509;84716090;Outras unidades de entrada/saida, para maquinas de processamento de dados;1;UN
8510;84717011;Unidades de discos magneticos, para discos flexiveis;1;UN
8511;84717012;Unidades de discos magneticos, para discos rigidos;1;UN
8512;84717019;Outras unidades de discos magneticos;1;UN
8513;84717021;Unidades de discos opticos, para leitura de dados;1;UN
8514;84717029;Outras unidades de discos opticos;1;UN
8515;84717032;Unidades de fitas magneticas, para cartuchos;1;UN
8516;84717033;Unidades de fitas magneticas, para cassetes;1;UN
8517;84717039;Outras unidades de fitas magneticas;1;UN
8518;84717090;Outras unidades de memoria;1;UN
8519;84718000;Outras unidades de maquinas automaticas para processamento de dados;1;UN
8520;84719011;Leitores ou gravadores de cartoes magneticos;1;UN
8521;84719012;Leitores de codigos de barras;1;UN
8522;84719013;Leitores de caracteres magnetizaveis;1;UN
8523;84719014;Digitalizadores de imagens (scanners);1;UN
8524;84719019;Outros leitores ou gravadores, de processamento de dados;1;UN
8525;84719090;Outras maquinas automaticas para processamento de dados, suas unidades;1;UN
8526;84721000;Duplicadores hectograficos ou a estencil, para escritorio;1;UN
8527;84723010;Maquinas automaticas para obliterar selos postais;1;UN
8528;84723020;Maquinas automaticas para selecao de correspondencia por formato e classificacao e distribuicao da mesma por leitura optica do codigo postal;1;UN
8529;84723030;Maquinas automaticas para selecao e distribuicao de encomendas, por leitura optica do codigo postal;1;UN
8530;84723090;Outras maquinas para selecionar, dobrar, envelopar ou cintar correspondencia, maquinas para abrir, fechar ou lacrar correspondencia e maquinas para colar ou obliterar selos;1;UN
8531;84729010;Distribuidores (dispensadores) automaticos de papeis-moeda, incluindo os que efetuam outras operacoes bancarias;1;UN
8532;84729021;Maquinas do tipo das utilizadas em caixas de banco, com dispositivo para autenticar, eletronicas, com capacidade de comunicacao bidirecional com computadores ou outras maquinas digitais;1;UN
8533;84729029;Outras maquinas bancarias, com dispositivos para autenticar;1;UN
8534;84729030;Maquinas para selecionar e contar moedas ou papeis-moeda;1;UN
8535;84729040;Maquinas para apontar lapis, perfuradores, grampeadores e desgrampeadores;1;UN
8536;84729051;Classificadoras automaticas de documentos, com leitores ou gravadores do item 8471.90.1 incorporados, com capacidade de classificacao superior a 400 documentos por minuto;1;UN
8537;84729059;Outras classificadoras automaticas de documentos, com leitores ou gravadores do item 8471.90.1 incorporados;1;UN
8538;84729091;Maquinas para imprimir enderecos ou para estampar placas de enderecos;1;UN
8539;84729099;Outras maquinas e aparelhos de escritorio, bancario, etc.;1;UN
8540;84732100;Partes e acessorios de maquinas de calcular eletronicas;1;KG
8541;84732910;Circuito impresso montado para caixa registradora;1;KG
8542;84732920;Partes e acessorios de outras maquinas de calcular/contabilidade;1;KG
8543;84732990;Partes e acessorios de maquinas de franquear, emitir tiquetes, etc;1;KG
8544;84733011;Gabinete com fonte de alimentacao para maquinas automaticas de processamento de dados;1;UN
8545;84733019;Outros gabinetes para maquinas automaticas de processamento de dados;1;UN
8546;84733031;Conjuntos cabeca-disco (HDA - Head Disk Assembly) de unidades de discos rigidos, montados;1;KG
8547;84733032;Bracos posicionadores de cabecas magneticas, para unidade de discos/fitas;1;KG
8548;84733033;Cabecas magneticas para unidades de discos ou de fitas;1;KG
8549;84733034;Mecanismos bobinadores para unidades de fitas magneticas (magnetic tape transporter);1;KG
8550;84733039;Outras partes e acessorios de unidades de discos/fitas magneticos;1;KG
8551;84733041;Placas-mae (mother boards), montadas, para maquinas de procesamento de dados;1;UN
8552;84733042;Placas (modulos) de memoria com uma superficie inferior ou igual a 50 cm2;1;UN
8553;84733043;Placas de microprocessamento, mesmo com dispositivo de dissipacao de calor;1;UN
8554;84733049;Outros circuitos impressos para maquinas automaticas de processamento de dados;1;UN
8555;84733092;Tela para microcomputadores portateis, policromatica;1;UN
8556;84733099;Outras partes e acessorios para maquinas automaticas de processamento de dados;1;KG
8557;84734010;Circuitos impressos com componentes eletricos ou eletronicos, montados, para maquinas e aparelhos de escritorio;1;UN
8558;84734070;Outras partes e acessorios das maquinas bancaria, distribuidoras de papel-moeda (do item 8472.90.10 e dos subitens 8472.90.21 ou 8472.90.29);1;KG
8559;84734090;Outras partes e acessorios para maquinas e aparelhos de escritorio, etc.;1;KG
8560;84735010;Circuitos impressos com componentes eletricos ou eletronicos, montados, que possam ser utilizados indiferentemente com as maquinas ou aparelhos de duas ou mais das posicoes 84.69 a 84.72;1;UN
8561;84735040;Cabecas magneticas, que possam ser utilizados indiferentemente com as maquinas ou aparelhos de duas ou mais das posicoes 84.69 a 84.72;1;KG
8562;84735050;Placas (modulos) de memoria com uma superficie inferior ou igual a 50 cm2, que possam ser utilizados indiferentemente com as maquinas ou aparelhos de duas ou mais das posicoes 84.69 a 84.72;1;UN
8563;84735090;Outras partes e acessorios que possam ser utilizados indiferentemente com as maquinas ou aparelhos de duas ou mais das posicoes 84.69 a 84.72;1;KG
8564;84741000;Maquinas e aparelhos para selecionar, peneirar, separar ou lavar substancias minerais solidas;1;UN
8565;84742010;Maquinas e aparelhos para esmagar, moer ou pulverizar substancias minerais solidas, de bolas;1;UN
8566;84742090;Outras maquinas e aparelhos para esmagar, moer ou pulverizar substancias minerais solidas;1;UN
8567;84743100;Betoneiras e aparelhos para amassar cimento;1;UN
8568;84743200;Maquinas para misturar materias minerais com betume;1;UN
8569;84743900;Outras maquinas e aparelhos para misturar/amassar substancias minerais solidas;1;UN
8570;84748010;Maquinas e aparelhos para fabricacao de moldes de areia para fundicao;1;UN
8571;84748090;Maquinas para aglomerar ou moldar combustiveis minerais solidos, pastas ceramicas, cimento, gesso ou outras materias minerais em po ou em pasta;1;UN
8572;84749000;Partes de maquinas e aparelhos para selecionar, peneirar, separar, lavar, esmagar, moer, misturar ou amassar terras, pedras, minerios ou outras substancias minerais solidas;1;KG
8573;84751000;Maquinas para montagem de lampadas, tubos ou valvulas, eletricos ou eletronicos, ou de lampadas de luz relampago (flash), que tenham involucro de vidro;1;UN
8574;84752100;Maquinas para fabricacao de fibras opticas e de seus esbocos;1;UN
8575;84752910;Maquinas para fabricacao de recipientes de vidro (posicao 70.10), exceto ampolas;1;UN
8576;84752990;Outras maquinas para fabricacao ou trabalho a quente do vidro ou das suas obras;1;UN
8577;84759000;Partes de maquinas para fabricacao ou trabalho a quente do vidro ou das suas obras;1;KG
8578;84762100;Maquinas automaticas de venda de bebidas, com dispositivo de aquecimento ou de refrigeracao incorporado;1;UN
8579;84762900;Outras maquinas automaticas de venda de bebidas;1;UN
8580;84768100;Maquinas automaticas para venda de alimentos, com dispositivo de aquecimento ou de refrigeracao incorporado;1;UN
8581;84768910;Maquinas automaticas de venda de selos postais;1;UN
8582;84768990;Maquinas automaticas de venda de outros produtos;1;UN
8583;84769000;Partes de maquinas automaticas de venda de produtos;1;KG
8584;84771011;Maquinas de moldar por injecao, horizontais, de comando numerico, monocolor, para materiais termoplasticos, com capacidade de injecao inferior ou igual a 5.000 g e forca de fechamento inferior ou igual a 12.000 kN;1;UN
8585;84771019;Outras maquinas de moldar borracha ou plasticos, por injecao, horizontais, de comando numerico;1;UN
8586;84771021;Outras maquinas de moldar, monocolor, para materiais termoplasticos, com capacidade de injecao inferior ou igual a 5.000 g e forca de fechamento inferior ou igual a 12.000 kN;1;UN
8587;84771029;Outras maquinas de moldar borracha ou plastico, por injecao horizontal;1;UN
8588;84771091;Outras maquinas de moldar borracha/plastico, por injecao, de comando numerico;1;UN
8589;84771099;Outras maquinas de moldar borracha/plastico, por injecao;1;UN
8590;84772010;Extrusora para materiais termoplasticos, com diametro da rosca inferior ou igual a 300 mm;1;UN
8591;84772090;Outras extrusoras para borracha ou plastico;1;UN
8592;84773010;Maquinas para fabricacao de recipientes termoplasticos de capacidade inferior ou igual a 5 litros, com uma producao inferior ou igual a 1.000 unidades por hora, referente a recipiente de 1 litro;1;UN
8593;84773090;Outras maquinas de moldar borracha/plastico, por insuflacao;1;UN
8594;84774010;Maquinas de moldar a vacuo poliestireno expandido (EPS) ou polipropileno expandido (EPP);1;UN
8595;84774090;Outras maquinas de moldar a vacuo ou de termoformar;1;UN
8596;84775100;Maquinas para moldar ou recauchutar pneumaticos ou para moldar ou dar forma a camaras de ar;1;UN
8597;84775911;Prensas para moldar borracha/plastico, com capacidade inferior ou igual a 30.000 kN;1;UN
8598;84775919;Outras prensas para moldar borracha/plastico;1;UN
8599;84775990;Outras maquinas e aparelhos para moldar borracha/plastico;1;UN
8600;84778010;Maquina de unir laminas de borracha entre si ou com tecidos com borracha, para fabricacao de pneumaticos;1;UN
8601;84778090;Outras maquinas e aparelhos para trabalhar borracha ou plasticos ou para fabricacao de produtos dessas materias;1;UN
8602;84779000;Partes maquinas e aparelhos para trabalhar borracha ou plasticos ou para fabricacao de produtos dessas materias;1;KG
8603;84781010;Batedoras-separadoras automaticas de talos e folhas de tabaco;1;UN
8604;84781090;Outras maquinas e aparelhos para preparar ou transformar tabaco;1;UN
8605;84789000;Partes de maquinas e aparelhos para preparar ou transformar tabaco;1;KG
8606;84791010;Maquinas e aparelhos automotrizes para espalhar e calcar pisos (pavimentos) betuminosos;1;UN
8607;84791090;Outras maquinas e aparelhos para obras publicas, construcao civil, etc;1;UN
8608;84792000;Maquinas e aparelhos para extracao ou preparacao de oleos ou gorduras vegetais fixos ou de oleos ou gorduras animais;1;UN
8609;84793000;Prensas para fabricacao de paineis de particulas, de fibras de madeira ou de outras materias lenhosas, e outras maquinas e aparelhos para tratamento de madeira ou de cortica;1;UN
8610;84794000;Maquinas para fabricacao de cordas ou cabos;1;UN
8611;84795000;Robos industriais, nao especificados nem compreendidos noutras posicoes;1;UN
8612;84796000;Aparelhos de evaporacao para arrefecimento do ar;1;UN
8613;84797100;Pontes de embarque para passageiros, dos tipos utilizados em aeroportos;1;UN
8614;84797900;Outras pontes de embarque para passageiros;1;UN
8615;84798110;Diferenciadores das tensoes de tracao de entrada e saida da chapa, em instalacoes de galvanoplastia;1;UN
8616;84798190;Outras maquinas e aparelhos para tratamento de metais;1;UN
8617;84798210;Outros misturadores;1;UN
8618;84798290;Outras maquinas e aparelhos para amassar, esmagar, moer, separar, etc.;1;UN
8619;84798911;Prensas;1;UN
8620;84798912;Distribuidores e doseadores de solidos ou de liquidos;1;UN
8621;84798921;Maquinas e aparelhos para cestaria ou espartaria;1;UN
8622;84798922;Maquinas e aparelhos para fabricacao de pinceis, brochas ou escovas;1;UN
8623;84798931;Limpadores de para-brisas eletricos, para aeronaves;1;UN
8624;84798932;Acumuladores hidraulicos, para aeronaves;1;UN
8625;84798940;Silos metalicos para cereais, fixos (nao transportaveis), incluindo as baterias, com mecanismos elevadores ou extratores incorporados;1;UN
8626;84798991;Aparelhos para limpar pecas por ultrassom;1;UN
8627;84798992;Maquinas de leme para embarcacoes;1;UN
8628;84798999;Outras maquinas e aparelhos mecanicos com funcao propria;1;UN
8629;84799010;Partes de limpadores de para-brisas, etc, para aeronaves;1;KG
8630;84799090;Outras partes de maquinas e aparelhos mecanicos com funcao propria;1;KG
8631;84801000;Caixas de fundicao;1;UN
8632;84802000;Placas de fundo para moldes;1;UN
8633;84803000;Modelos para moldes;1;UN
8634;84804100;Moldes para metais ou carbonetos metalicos, para moldagem por injecao ou por compressao;1;UN
8635;84804910;Coquilhas para metais/carbonetos metalicos;1;UN
8636;84804990;Outros moldes para metais/carbonetos metalicos;1;UN
8637;84805000;Moldes para vidros;1;UN
8638;84806000;Moldes para materias minerais;1;UN
8639;84807100;Moldes para borracha ou plasticos, para moldagem por injecao ou por compressao;1;UN
8640;84807900;Outros moldes para borracha ou plasticos;1;UN
8641;84811000;Valvulas redutoras de pressao;1;UN
8642;84812011;Valvulas para transmissoes oleo-hidraulicas ou pneumaticas, rotativas, de caixas de direcao hidraulica, com pinhao;1;UN
8643;84812019;Outras valvulas para transmissoes oleo-hidraulicas ou pneumaticas, rotativas, de caixas de direcao hidraulica;1;UN
8644;84812090;Outras valvulas para transmissoes oleo-hidraulicas ou pneumaticas;1;UN
8645;84813000;Valvulas de retencao;1;UN
8646;84814000;Valvulas de seguranca ou de alivio;1;UN
8647;84818011;Valvulas para escoamento, dos tipos utilizados em banheiros ou cozinhas;1;UN
8648;84818019;Outros dispositivos dos tipos utilizados em banheiros ou cozinhas;1;UN
8649;84818021;Valvulas de expansao termostaticas ou pressostaticas;1;UN
8650;84818029;Outros dispositivos utilizados em refrigeracao;1;UN
8651;84818031;Outras valvulas, dos tipos utilizados em equipamentos a gas, com uma pressao de trabalho inferior ou igual a 50 mbar e dispositivo de seguranca termoeletrico incorporado, dos tipos utilizados em aparelhos domesticos;1;UN
8652;84818039;Outras valvulas dos tipos utilizados em equipamentos a gas;1;UN
8653;84818091;Valvulas tipo aerossol;1;UN
8654;84818092;Valvulas solenoides;1;UN
8655;84818093;Valvulas tipo gaveta;1;UN
8656;84818094;Valvulas tipo globo;1;UN
8657;84818095;Valvulas tipo esfera;1;UN
8658;84818096;Valvulas tipo macho;1;UN
8659;84818097;Valvulas tipo borboleta;1;UN
8660;84818099;Torneiras, e dispositivos semelhantes, para canalizacoes;1;UN
8661;84819010;Partes de valvulas tipo aerossol ou dos dispositivos do item 8481.80.1 (dispositivos utilizados em banheiros, etc);1;KG
8662;84819090;Partes de torneiras, outros dispositivos para canalizacoes, etc.;1;KG
8663;84821010;Rolamentos de esferas, de carga radial;1;UN
8664;84821090;Outros rolamentos de esferas;1;UN
8665;84822010;Rolamentos de roletes conicos, incluindo os conjuntos constituidos por cones e roletes conicos, de carga radial;1;UN
8666;84822090;Outros rolamentos de roletes conicos;1;UN
8667;84823000;Rolamentos de roletes em forma de tonel;1;UN
8668;84824000;Rolamentos de agulhas;1;UN
8669;84825010;Rolamentos de roletes cilindricos, de carga radial;1;UN
8670;84825090;Outros rolamentos de roletes cilindricos;1;UN
8671;84828000;Outros rolamentos de roletes, incluindo os rolamentos combinados;1;UN
8672;84829111;Esferas de aco calibradas, para carga de canetas esferograficas;1;KG
8673;84829119;Outras esferas de aco calibradas, para rolamentos;1;KG
8674;84829120;Roletes cilindricos para rolamentos;1;KG
8675;84829130;Roletes conicos para rolamentos;1;KG
8676;84829190;Outras esferas, roletes e agulhas, para rolamentos;1;KG
8677;84829910;Selos, capas e porta-esferas de aco;1;KG
8678;84829990;Outras partes de rolamentos;1;KG
8679;84831011;Virabrequins forjados, de peso superior ou igual a 900 kg e comprimento superior ou igual a 2.000 mm;1;UN
8680;84831019;Outros virabrequins;1;UN
8681;84831020;Arvores de cames para comando de valvulas;1;UN
8682;84831030;Veios flexiveis de transmissao;1;UN
8683;84831040;Manivelas;1;UN
8684;84831050;Arvores de transmissao providas de acoplamentos dentados com entalhes de protecao contra sobrecarga, de comprimento superior ou igual a 1500 mm e diametro do eixo superior ou igual a 400 mm;1;UN
8685;84831090;Outras arvores (veios) de transmissao;1;UN
8686;84832000;Mancais (chumaceiras) com rolamentos incorporados;1;UN
8687;84833010;Mancais (chumaceiras) sem rolamentos, montados com bronzes de metal antifriccao;1;UN
8688;84833021;Bronzes, com diametro interno superior ou igual a 200 mm;1;UN
8689;84833029;Outros bronzes;1;UN
8690;84833090;Outros mancais sem rolamentos;1;UN
8691;84834010;Redutores, multiplicadores, caixas de transmissao e variadores de velocidade, incluindo os conversores de torque;1;UN
8692;84834090;Engrenagens e rodas de friccao, eixos de esferas/roletes;1;UN
8693;84835010;Polias, exceto as de rolamentos reguladoras de tensao;1;UN
8694;84835090;Volantes e outras polias;1;UN
8695;84836011;Embreagens de friccao;1;UN
8696;84836019;Outras embreagens;1;UN
8697;84836090;Dispositivos de acoplamento, inclusive juntas de articulacao;1;UN
8698;84839000;Rodas dentadas e outros orgaos elementares de transmissao apresentados separadamente, partes;1;KG
8699;84841000;Juntas metaloplasticas;1;KG
8700;84842000;Juntas de vedacao, mecanicas;1;KG
8701;84849000;Jogos ou sortidos de juntas de composicoes diferentes, apresentados em bolsas, envelopes ou embalagens semelhantes;1;KG
8702;84861000;Maquinas e aparelhos para a fabricacao de esferas (boules) ou de plaquetas (wafers);1;UN
8703;84862000;Maquinas e aparelhos para a fabricacao de dispositivos semicondutores ou de circuitos integrados eletronicos;1;UN
8704;84863000;Maquinas e aparelhos para a fabricacao de dispositivos de visualizacao de tela plana;1;UN
8705;84864000;Maquinas e aparelhos especificados na Nota 9 C) do presente Capitulo;1;UN
8706;84869000;Partes e acessorios de maquinas/aparelhos para fabricar esferas/plaquetas;1;KG
8707;84871000;Helices para embarcacoes e suas pas;1;UN
8708;84879000;Partes de outras maquina ou aparelhos sem conexao eletrica, etc;1;KG
8709;85011011;Motores de potencia nao superior a 37,5 W, de corrente continua, de passo inferior ou igual a 1,8�;1;UN
8710;85011019;Outros motores eletricos, de corrente continua, de potencia nao superior a 37,5 W;1;UN
8711;85011021;Motores de potencia nao superior a 37,5 W, de corrente alternada, sincronos;1;UN
8712;85011029;Outros motores eletricos de corrente alternada, de potencia nao superior a 37,5 W;1;UN
8713;85011030;Motores eletricos universais, de potencia nao superior a 37,5 W;1;UN
8714;85012000;Motores universais de potencia superior a 37,5 W, eletricos;1;UN
8715;85013110;Motor eletrico de corrente continua, de potencia nao superior a 750 W;1;UN
8716;85013120;Gerador eletrico de corrente continua, de potencia nao superior a 750 W;1;UN
8717;85013210;Motor eletrico de corrente continua, de potencia superior a 750 W, mas nao superior a 75 kW;1;UN
8718;85013220;Gerador eletrico de corrente continua, de potencia superior a 750 W, mas nao superior a 75 kW;1;UN
8719;85013310;Motor eletrico de corrente continua, de potencia superior a 75 kW, mas nao superior a 375 kW;1;UN
8720;85013320;Gerador eletrico de corrente continua, de potencia superior a 75 kW, mas nao superior a 375 kW;1;UN
8721;85013411;Motor eletrico de corrente continua, de potencia inferior ou igual a 3.000 kW;1;UN
8722;85013419;Outros motores eletricos de corrente continua, de potencia superior a 375 kW;1;UN
8723;85013420;Geradores eletricos de corrente continua, potencia > 375kw;1;UN
8724;85014011;Outros motores de corrente alternada, monofasicos, de potencia inferior ou igual a 15 kW, sincronos;1;UN
8725;85014019;Outros motores de corrente alternada, monofasicos, de potencia inferior ou igual a 15 kW;1;UN
8726;85014021;Outros motores de corrente alternada, monofasicos, de potencia superior a 15 kW, sincronos;1;UN
8727;85014029;Outros motores de corrente alternada, monofasicos, de potencia superior a 15 kW;1;UN
8728;85015110;Outros motores de corrente alternada, polifasicos, de potencia nao superior a 750 W, trifasicos, com rotor de gaiola;1;UN
8729;85015120;Outros motores de corrente alternada, polifasicos, de potencia nao superior a 750 W, trifasicos, com rotor de aneis;1;UN
8730;85015190;Outros motores eletricos de corrente alternada, polifasicos, de potencia nao superior a 750 W;1;UN
8731;85015210;Motor eletrico de corrente alternada, trifasico, de potencia superior a 750 W, mas nao superior a 75 kW, com rotor de gaiola;1;UN
8732;85015220;Motor eletrico de corrente alternada, trifasico, de potencia superior a 750 W, mas nao superior a 75 kW, com rotor de aneis;1;UN
8733;85015290;Outros motores eletricos de corrente alternada, polifasicos, de potencia superior a 750 W, mas nao superior a 75 kW;1;UN
8734;85015310;Motor eletrico de corrente alternada, trifasico, de potencia inferior ou igual a 7.500 kW;1;UN
8735;85015320;Motor eletrico de corrente alternada, trifasico, de potencia superior a 7.500 kW mas nao superior a 30.000 kW;1;UN
8736;85015330;Motor eletrico de corrente alternada trifasico, de potencia superior a 30.000 kW mas nao superior a 50.000 kW;1;UN
8737;85015390;Outros motores eletricos de corrente alternada, polifasicos, potencia maior que 30.000 Kw;1;UN
8738;85016100;Geradores de corrente alternada, potencia <= 75 kva;1;UN
8739;85016200;Geradores de corrente alternada, 75 kva < potencia <= 375 kva;1;UN
8740;85016300;Geradores de corrente alternada, 375 kva < potencia <= 750 kva;1;UN
8741;85016400;Geradores de corrente alternada, potencia > 750 kva;1;UN
8742;85021110;Grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia nao superior a 75 kVA, de corrente alternada;1;UN
8743;85021190;Outros grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia nao superior a 75 kVA;1;UN
8744;85021210;Grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia superior a 75 kVA, mas nao superior a 375 kVA, de corrente alternada;1;UN
8745;85021290;Outros grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia superior a 75 kVA, mas nao superior a 375 kVA;1;UN
8746;85021311;Grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia inferior ou igual a 430 kVA, de corrente alternada;1;UN
8747;85021319;Grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia superior a 375 kVA, de corrente alternada;1;UN
8748;85021390;Grupos eletrogeneos de motor de pistao, de ignicao por compressao (motores diesel ou semidiesel), de potencia superior a 375 kVA;1;UN
8749;85022011;Grupos eletrogeneos de motor de pistao, de ignicao por centelha (motor de explosao), de corrente alternada, de potencia inferior ou igual a 210 kVA;1;UN
8750;85022019;Outros grupos eletrogeneos de motor de pistao, de ignicao por centelha (motor de explosao), de corrente alternada;1;UN
8751;85022090;Outros grupos eletrogeneos para motor a explosao;1;UN
8752;85023100;Outros grupos eletrogeneos de energia eolica;1;UN
8753;85023900;Outros grupos eletrogeneos;1;UN
8754;85024010;Conversores rotativos eletricos, de frequencia;1;UN
8755;85024090;Outros conversores rotativos eletricos;1;UN
8756;85030010;Partes de motores/geradores de potencia <= 75 kva;1;KG
8757;85030090;Partes de outros motores/geradores/grupos eletrogeradores, etc.;1;KG
8758;85041000;Reatores para lampadas/tubos de descargas;1;UN
8759;85042100;Transformadores de dieletrico liquido, de potencia nao superior a 650 kVA;1;UN
8760;85042200;Transformadores de dieletrico liquido, de potencia superior a 650 kVA, mas nao superior a 10.000 kVA;1;UN
8761;85042300;Transformadores de dieletrico liquido, de potencia superior a 10.000 kVA;1;UN
8762;85043111;Transformadores de corrente, eletricos, para frequencias inferiores ou iguais a 60 Hz, de potencia nao superior a 1 kVA;1;UN
8763;85043119;Outros transformadores eletricos, para frequencias inferiores ou iguais a 60 Hz, de potencia nao superior a 1 kVA;1;UN
8764;85043191;Transformador eletrico de saida horizontal (fly back), com tensao de saida superior a 18 kV e frequencia de varredura horizontal superior ou igual a 32 kHz, de potencia nao superior a 1 kVA;1;UN
8765;85043192;Transformadores eletricos de FI, de deteccao, de relacao, de linearidade ou de foco, de potencia nao superior a 1 kVA;1;UN
8766;85043199;Outros transformadores eletricos de potencia nao superior a 1 kVA;1;UN
8767;85043211;Transformadores eletricos, de potencia inferior ou igual a 3 kVA, para frequencias inferiores ou iguais a 60 Hz;1;UN
8768;85043219;Outros transformadores eletricos de potencia inferior ou igual a 3 kVA;1;UN
8769;85043221;Transformadores eletricos, de potencia superior a 3 kVA, para frequencias inferiores ou iguais a 60 Hz;1;UN
8770;85043229;Outros transformadores eletricos de potencia superior a 3 kVA;1;UN
8771;85043300;Transformadores eletricos, de potencia superior a 16 kVA, mas nao superior a 500 kVA;1;UN
8772;85043400;Transformador eletrico de potencia superior a 500 kVA;1;UN
8773;85044010;Carregadores de acumuladores (conversores estaticos);1;UN
8774;85044021;Retificadores, exceto carregadores de acumuladores, de cristal (semicondutores);1;UN
8775;85044022;Retificadores, exceto carregadores de acumuladores, eletroliticos;1;UN
8776;85044029;Outros retificadores, exceto carregadores de acumuladores;1;UN
8777;85044030;Conversores eletricos de corrente continua;1;UN
8778;85044040;Equipamento de alimentacao ininterrupta de energia (UPS ou No break);1;UN
8779;85044050;Conversores eletronicos de frequencia, para variacao de velocidade de motores eletricos;1;UN
8780;85044060;Aparelhos eletronicos de alimentacao de energia dos tipos utilizados para iluminacao de emergencia;1;UN
8781;85044090;Outros conversores eletricos estaticos;1;UN
8782;85045000;Outras bobinas de reatancia e de auto-inducao;1;UN
8783;85049010;Nucleos de po ferromagnetico;1;KG
8784;85049020;Partes de reatores para lampadas ou tubos de descarga;1;KG
8785;85049030;Partes de transformadores das subposicoes 8504.21, 8504.22, 8504.23, 8504.33 ou 8504.34 (dieletricos liquidos ou de potencia > 16 Kva;1;KG
8786;85049040;Partes de conversores estaticos, exceto de carregadores de acumuladores e de retificadores;1;KG
8787;85049090;Outras partes de outros transformadores, conversores, etc;1;KG
8788;85051100;Imas permanentes e artefatos destinados a tornarem-se imas permanentes apos magnetizacao, de metal;1;KG
8789;85051910;Imas permanentes e artefatos destinados a tornarem-se imas permanentes apos magnetizacao, de ferrita (ceramicos);1;KG
8790;85051990;Outros imas permanentes e artefatos destinados a tornarem-se imas permanentes apos magnetizacao;1;KG
8791;85052010;Freios que atuam por corrente de Foucault, do tipo dos utilizados nos veiculos das posicoes 87.01 a 87.05 (veiculos automoveis);1;UN
8792;85052090;Acoplamentos, embreagens, variadores de velocidade, eletromagneticos;1;KG
8793;85059010;Eletroimas;1;UN
8794;85059080;Placas, mandris e dispositivos magneticos, etc, de fixacao;1;KG
8795;85059090;Partes de acoplamentos, embreagens, etc, eletromagneticos;1;KG
8796;85061010;Pilhas alcalinas, de dioxido de manganes;1;UN
8797;85061020;Outras pilhas, de dioxido de manganes;1;UN
8798;85061030;Baterias de pilhas, de dioxido de manganes;1;UN
8799;85063010;Pilhas e baterias de pilhas, de oxido de mercurio, com volume exterior nao superior a 300 cm3;1;UN
8800;85063090;Outras pilhas e baterias de pilhas, de oxido de mercurio;1;UN
8801;85064010;Pilhas e baterias de pilhas, de oxido de prata, com volume exterior nao superior a 300 cm3;1;UN
8802;85064090;Outras pilhas e baterias de pilhas, de oxido de praa;1;UN
8803;85065010;Pilhas e baterias de pilhas, eletricas, de litio, com volume exterior nao superior a 300 cm3;1;UN
8804;85065090;Outras pilhas e baterias de pilhas, eletricas, de litio;1;UN
8805;85066010;Pilhas e baterias de pilhas, eletricas, ar-zinco, com volume exterior nao superior a 300 cm3;1;UN
8806;85066090;Outras pilhas e baterias de pilhas, eletricas, ar-zinco;1;UN
8807;85068010;Outras pilhas e baterias de pilhas, com volume exterior nao superior a 300 cm3;1;UN
8808;85068090;Outras pilhas/baterias eletricas;1;UN
8809;85069000;Partes de pilhas/baterias de pilhas, eletricas;1;KG
8810;85071010;Acumuladores eletricos de chumbo, do tipo utilizado para o arranque dos motores de pistao, de capacidade inferior ou igual a 20 Ah e tensao inferior ou igual a 12 V;1;UN
8811;85071090;Outros acumuladores eletricos de chumbo;1;UN
8812;85072010;Outros acumuladores eletricos, de chumbo, peso <= 1000 kg;1;UN
8813;85072090;Outros acumuladores eletricos, de chumbo;1;UN
8814;85073011;Acumuladores eletricos de niquel-cadmio, peso <= 2500 kg, capacidade <= 15 ah;1;UN
8815;85073019;Outros acumuladores eletricos, de niquel-cadmio, peso <= 2500 kg;1;UN
8816;85073090;Outros acumuladores eletricos, de niquel-cadmio;1;UN
8817;85074000;Acumuladores eletricos de niquel-ferro;1;UN
8818;85075000;Acumuladores eletricos de niquel-hidreto metalico;1;UN
8819;85076000;Acumuladores eletricos de ion de litio;1;UN
8820;85078000;Outros acumuladores eletricos;1;UN
8821;85079010;Separadores para acumuladores eletricos;1;UN
8822;85079020;Recipientes de plastico, suas tampas e tampoes, para acumuladores eletricos;1;KG
8823;85079090;Outras partes para acumuladores eletricos;1;KG
8824;85081100;Aspiradores com motor eletrico incorporado, de potencia nao superior a 1.500 W e cujo volume do reservatorio nao exceda 20 litros;1;UN
8825;85081900;Outros aspiradores com motor eletrico incorporado;1;UN
8826;85086000;Outros aspiradores;1;UN
8827;85087000;Partes para aspiradores;1;KG
8828;85094010;Liquidificador de alimentos, com motor eletrico incorporado, de uso domestico;1;UN
8829;85094020;Batedeiras de alimentos, com motor eletrico incorporado, de uso domestico;1;UN
8830;85094030;Moedores de carne, com motor eletrico incorporado, de uso domestico;1;UN
8831;85094040;Extratores centrifugos de sucos, com motor eletrico incorporado, de uso domestico;1;UN
8832;85094050;Aparelhos de funcoes multiplas, providos de acessorios intercambiaveis, para processar alimentos, com motor eletrico incorporado, de uso domestico;1;UN
8833;85094090;Outros trituradores, etc, para alimentos, com motor eletrico incorporado, de uso domestico;1;UN
8834;85098010;Enceradeiras de pisos eletromecanicas - uso domestico;1;UN
8835;85098090;Outros aparelhos eletromecanicos com motor eletrico incorporado, uso domestico;1;UN
8836;85099000;Partes de aparelhos eletromecanicos com motor eletrico incorporado, uso domestico;1;KG
8837;85101000;Aparelhos ou maquinas de barbear, com motor eletrico incorporado;1;UN
8838;85102000;Maquinas de cortar o cabelo ou de tosquiar, com motor eletrico incorporado;1;UN
8839;85103000;Aparelhos de depilar, com motor eletrico incorporado;1;UN
8840;85109011;Laminas de aparelhos ou maquinas de barbear com motor eletrico incorporado;1;UN
8841;85109019;Outras partes de aparelhos ou maquinas de barbear com motor eletrico incorporado;1;KG
8842;85109020;Pentes e contrapentes para maquinas de tosquiar;1;KG
8843;85109090;Partes de maquinas para cortar cabelo/tosquiar, com motor eletrico;1;KG
8844;85111000;Velas de ignicao para motores de ignicao por centelha ou por compressao;1;UN
8845;85112010;Magnetos para motores de ignicao por centelha ou por compressao;1;UN
8846;85112090;Dinamos-magnetos, volantes magneticos, para motores de ignicao por centelha ou por compressao;1;UN
8847;85113010;Distribuidores para motores de ignicao por centelha ou por compressao;1;UN
8848;85113020;Bobinas de ignicao para motores de ignicao por centelha ou por compressao;1;UN
8849;85114000;Motores de arranque, mesmo funcionando como geradores, para motores de ignicao por centelha ou por compressao;1;UN
8850;85115010;Dinamos e alternadores para motores de ignicao por centelha ou por compressao;1;UN
8851;85115090;Outros geradores para motores de ignicao por centelha ou por compressao;1;UN
8852;85118010;Velas de aquecimento para motores de ignicao por centelha ou por compressao;1;UN
8853;85118020;Reguladores de voltagem (conjuntores-disjuntores) para motores de ignicao por centelha ou por compressao;1;UN
8854;85118030;Ignicao eletronica digital para motor explosao/diesel;1;UN
8855;85118090;Outros aparelhos e dispositivos eletronicos de ignicao, etc, para motores a explosao;1;UN
8856;85119000;Partes de aparelhos e dispositivos eletronicos de ignicao, etc, para motores a explosao;1;KG
8857;85121000;Aparelhos de iluminacao ou de sinalizacao visual dos tipos utilizados em bicicletas, eletricos;1;UN
8858;85122011;Farois para automoveis e outros ciclos;1;UN
8859;85122019;Outros aparelhos eletricos de iluminacao para automoveis e outros ciclos;1;UN
8860;85122021;Luzes fixas para automoveis e outros ciclos;1;UN
8861;85122022;Luzes indicadoras de manobras, dos tipos utilizados em ciclos ou automoveis;1;UN
8862;85122023;Caixas de luzes combinadas dos tipos utilizados em ciclos ou automoveis;1;UN
8863;85122029;Outros aparelhos eletricos de sinalizacao visual, dos tipos utilizados em ciclos ou automoveis;1;UN
8864;85123000;Aparelhos de sinalizacao acustica, dos tipos utilizados em ciclos ou automoveis;1;UN
8865;85124010;Limpadores de para-brisas para automoveis;1;UN
8866;85124020;Degeladores e desembacadores, dos tipos utilizados em ciclos ou automoveis;1;UN
8867;85129000;Partes de aparelhos eletricos de iluminacao ou de sinalizacao, dos tipos utilizados em ciclos ou automoveis;1;KG
8868;85131010;Lanternas manuais;1;UN
8869;85131090;Outras lanternas eletricas portateis, destinadas a funcionar por meio de sua propria fonte de energia (por exemplo, de pilhas, de acumuladores, de magnetos);1;UN
8870;85139000;Partes de lanternas eletricas portateis, destinadas a funcionar por meio de sua propria fonte de energia (por exemplo, de pilhas, de acumuladores, de magnetos);1;KG
8871;85141010;Fornos de resistencia (de aquecimento indireto), industriais;1;UN
8872;85141090;Fornos de resistencia (de aquecimento indireto), de laboratorio;1;UN
8873;85142011;Fornos que funcionam por inducao, industriais;1;UN
8874;85142019;Fornos que funcionam por inducao, de laboratorio;1;UN
8875;85142020;Fornos que funcionam por perdas dieletricas, industriais ou de laboratorio;1;UN
8876;85143011;Fornos de resistencia (de aquecimento direto), industriais;1;UN
8877;85143019;Fornos de resistencia (de aquecimento direto), de laboratorio;1;UN
8878;85143021;Fornos de arco voltaico, industriais;1;UN
8879;85143029;Fornos de arco voltaico, de laboratorio;1;UN
8880;85143090;Outros fornos eletricos industriais ou de laboratorio;1;UN
8881;85144000;Outros aparelhos para tratamento termico de materias por inducao ou por perdas dieletricas;1;UN
8882;85149000;Partes de fornos eletricos, industriais ou de laboratorio, etc.;1;KG
8883;85151100;Ferros e pistolas para soldadura forte ou fraca;1;UN
8884;85151900;Outras maquinas e aparelhos para soldadura forte ou fraca;1;UN
8885;85152100;Maquinas e aparelhos para soldar metais por resistencia, inteira ou parcialmente automaticos;1;UN
8886;85152900;Outras maquinas e aparelhos para soldar metais por resistencia;1;UN
8887;85153110;Robos para soldar, por arco, em atmosfera inerte (MIG - Metal Inert Gas) ou atmosfera ativa (MAG - Metal Active Gas), de comando numerico;1;UN
8888;85153190;Outras maquinas e aparelhos para soldar metais por arco ou jato de plasma, inteira ou parcialmente automaticos;1;UN
8889;85153900;Outras maquinas e aparelhos para soldar metais por arco ou jato de plasma;1;UN
8890;85158010;Outras maquinas e aparelhos para soldar a laser;1;UN
8891;85158090;Outras maquinas e aparelhos para soldar, eletricas, por outros processos;1;UN
8892;85159000;Partes de maquinas e aparelhos para soldar, eletricos;1;KG
8893;85161000;Aquecedores eletricos de agua, incluindo os de imersao;1;UN
8894;85162100;Radiadores de acumulacao, eletricos, para aquecimento de ambientes, do solo ou para usos semelhantes;1;UN
8895;85162900;Outros aparelhos eletricos para aquecimento de ambientes, uso domestico;1;UN
8896;85163100;Secadores de cabelo, eletrotermicos, uso domestico;1;UN
8897;85163200;Outros aparelhos para arranjos do cabelo, eletrotermico, uso domestico;1;UN
8898;85163300;Aparelhos para secar as maos, eletrotermicos, uso domestico;1;UN
8899;85164000;Ferros eletricos de passar, uso domestico;1;UN
8900;85165000;Fornos de microondas, uso domestico;1;UN
8901;85166000;Outros fornos, fogoes de cozinha, fogareiros (incluindo as chapas de coccao), grelhas e assadeiras, eletrotermicos, uso domestico;1;UN
8902;85167100;Aparelhos para preparacao de cafe ou de cha, eletrotermicos;1;UN
8903;85167200;Torradeiras de pao, eletrotermicas, uso domestico;1;UN
8904;85167910;Panelas eletrotermicas, uso domestico;1;UN
8905;85167920;Fritadoras eletrotermicas, uso domestico;1;UN
8906;85167990;Outros aparelhos eletrotermicos, uso domestico;1;UN
8907;85168010;Resistencias de aquecimento, para aparelhos da presente posicao (eletrotermico, uso domestico);1;UN
8908;85168090;Outras resistencias de aquecimento, uso domestico;1;UN
8909;85169000;Partes de aquecedores e aparelhos eletricos para aquecimento, uso domestico;1;KG
8910;85171100;Aparelhos telefonicos por fio com unidade auscultador-microfone sem fio;1;UN
8911;85171211;Telefones para redes celulares e para outras redes sem fio, de radiotelefonia, analogicos, portateis (por exemplo, walkie talkie e handle talkie);1;UN
8912;85171212;Telefones para redes celulares e para outras redes sem fio, de radiotelefonia, analogicos, fixos, sem fonte propria de energia, monocanais;1;UN
8913;85171213;Telefones para redes celulares e para outras redes sem fio, de radiotelefonia, analogicos, moveis, do tipo dos utilizados em veiculos automoveis;1;UN
8914;85171219;Outros telefones para redes celulares e para outras redes sem fio, de radiotelefonia, analogicos;1;UN
8915;85171221;Aparelhos de sistema troncalizado (trunking), portateis;1;UN
8916;85171222;Aparelhos de sistema troncalizado (trunking), fixos, sem fonte propria de energia;1;UN
8917;85171223;Aparelhos de sistema troncalizado (trunking), do tipo dos utilizados em veiculos automoveis;1;UN
8918;85171229;Outros aparelhos transmissores/receptores de sistema troncalizado;1;UN
8919;85171231;Terminais portateis de telefonia celular;1;UN
8920;85171232;Terminais fixos de telefonia celular, sem fonte propria de energia;1;UN
8921;85171233;Terminais moveis, do tipo dos utilizados em veiculos automoveis;1;UN
8922;85171239;Outros aparelhos transmissores e receptores de telefonia celular;1;UN
8923;85171241;Aparelhos de telecomunicacao por satelite, digitais, operando em banda C, Ku, L ou S;1;UN
8924;85171249;Outros aparelhos transmissores/receptores de telecomunicacao por satelite;1;UN
8925;85171290;Outros aparelhos transmissores com receptor incorporado;1;UN
8926;85171810;Interfones;1;UN
8927;85171820;Telefones publicos;1;UN
8928;85171891;Outros telefones nao combinados com outros aparelhos;1;UN
8929;85171899;Outros aparelhos telefonicos, inclusive videofones;1;UN
8930;85176111;Estacoes-base, de sistema bidirecional de radiomensagens, de taxa de transmissao inferior ou igual a 112 kbits/s;1;UN
8931;85176119;Outras estacoes-base, de sistema bidirecional de radiomensagens;1;UN
8932;85176120;Aparelho de sistema troncalizado (trunking), para estacao-base;1;UN
8933;85176130;Aparelho transmissor de telefonia celular, para estacao-base;1;UN
8934;85176141;Estacoes-base, de telecomunicacao por satelite, principal terrena fixa, sem conjunto antena-refletor;1;UN
8935;85176142;Estacoes-base, de telecomunicacao por satelite, VSAT (Very Small Aperture Terminal), sem conjunto antena-refletor;1;UN
8936;85176143;Estacoes-base, de telecomunicacao por satelite, digitais, operando em banda C, Ku, L ou S;1;UN
8937;85176149;Outras estacoes-base, de telecomunicacao por satelite;1;UN
8938;85176191;Outros aparelhos para emissao, transmissao ou recepcao de voz, imagens ou outros dados, digitais, de frequencia superior ou igual a 15 GHz e inferior ou igual a 23 GHz e taxa de transmissao inferior ou igual a 8 Mbits/s;1;UN
8939;85176192;Outros aparelhos para emissao, transmissao ou recepcao de voz, imagens ou outros dados, digitais, de frequencia superior a 23 GHz;1;UN
8940;85176199;Outros aparelhos transmissores com receptor incorporado;1;UN
8941;85176211;Multiplexadores por divisao de frequencia;1;UN
8942;85176212;Multiplexadores por divisao de tempo, digitais sincronos, com velocidade de transmissao igual ou superior a 155 Mbits/s;1;UN
8943;85176213;Outros multiplexadores por divisao de tempo;1;UN
8944;85176214;Concentradores de linhas de assinantes (terminais de central ou terminal remoto);1;UN
8945;85176219;Outros concentradores;1;UN
8946;85176221;Centrais automaticas publicas, para comutacao eletronica, incluindo as de transito;1;UN
8947;85176222;Centrais automaticas privadas, de capacidade inferior ou igual a 25 ramais;1;UN
8948;85176223;Centrais automaticas privadas, de capacidade superior a 25 ramais e inferior ou igual a 200 ramais;1;UN
8949;85176224;Centrais automaticas privadas, de capacidade superior a 200 ramais;1;UN
8950;85176229;Outras centrais automaticas comutacao linha telefonica, exceto videotexto;1;UN
8951;85176231;Centrais automaticas para comutacao por pacote com velocidade de tronco superior a 72 kbits/s e de comutacao superior a 3.600 pacotes por segundo, sem multiplexacao deterministica;1;UN
8952;85176232;Outras centrais automaticas para comutacao por pacote;1;UN
8953;85176233;Centrais automaticas de sistema troncalizado (trunking);1;UN
8954;85176239;Outros aparelhos de comutacao para telefonia e telegrafia;1;UN
8955;85176241;Roteadores digitais, em redes com ou sem fio, com capacidade de conexao sem fio;1;UN
8956;85176248;Outros roteadores digitais, em redes com ou sem fio, com velocidade de interface serial de pelo menos 4 Mbits/s, proprios para interconexao de redes locais com protocolos distintos;1;UN
8957;85176249;Outros roteadores digitais;1;UN
8958;85176251;Terminais ou repetidores sobre linhas metalicas;1;UN
8959;85176252;Terminais sobre linhas de fibras opticas, com velocidade de transmissao superior a 2,5 Gbits/s;1;UN
8960;85176253;Terminais de texto que operem com codigo de transmissao Baudot, providos de teclado alfanumerico e visor, mesmo com telefone incorporado;1;UN
8961;85176254;Distribuidores de conexoes para redes (hubs);1;UN
8962;85176255;Moduladores/demoduladores (modems);1;UN
8963;85176259;Outros equipamentos terminais ou repetidores;1;UN
8964;85176261;Aparelhos emissores com receptor incorporado de sistema troncalizado (trunking);1;UN
8965;85176262;Aparelhos emissores com receptor incorporado de tecnologia celular;1;UN
8966;85176264;Aparelhos emissores com receptor incorporado por satelite, digitais, operando em banda C, Ku, L ou S;1;UN
8967;85176265;Outros aparelhos transmissores/receptores por satelite;1;UN
8968;85176271;Terminais portateis de sistema bidirecional de radiomensagens, de taxa de transmissao inferior ou igual a 112 kbits/s;1;UN
8969;85176272;Aparelhos emissores de frequencia inferior a 15 GHz e de taxa de transmissao inferior ou igual a 34 Mbits/s, exceto os de sistema bidirecional de radiomensagens de taxa de transmissao inferior ou igual a 112 kbits/s;1;UN
8970;85176277;Outros aparelhos emissores com receptor incorporado, digitais, de frequencia inferior a 15 GHz;1;UN
8971;85176278;Outros aparelhos emissores com receptor incorporado, digitais, de frequencia superior ou igual a 15 GHz, mas inferior ou igual a 23 GHz e taxa de transmissao inferior ou igual a 8 Mbit/s;1;UN
8972;85176279;Outros aparelhos emissores com receptor incorporado, digitais;1;UN
8973;85176291;Aparelhos transmissores (emissores) de radiotelefonia/radiotelegrafia;1;UN
8974;85176292;Receptores pessoais de radiomensagens com apresentacao alfanumerica da mensagem em visor;1;UN
8975;85176293;Outros receptores pessoais de radiomensagens;1;UN
8976;85176294;Tradutores (conversores) de protocolos para interconexao de redes (gateways);1;UN
8977;85176295;Terminais fixos, analogicos, sem fonte propria de energia, monocanais;1;UN
8978;85176296;Outros aparelhos de radiotelefonia, radiotelegrafia, analogicos;1;UN
8979;85176299;Outros aparelhos receptores radiotelefonia/radiotelegrafia/radiofonia;1;UN
8980;85176900;Outros aparelhos eletricos para telefonia/telegrafia, por fio;1;UN
8981;85177010;Circuitos impressos com componentes eletricos ou eletronicos, montados;1;UN
8982;85177021;Antenas proprias para telefones celulares portateis, exceto as telescopicas;1;UN
8983;85177029;Outras antenas exceto para telefones celulares;1;UN
8984;85177091;Gabinetes, bastidores e armacoes, para aparelhos transmissores/receptores;1;UN
8985;85177092;Registradores e seletores para centrais automaticas;1;UN
8986;85177099;Outras partes para aparelhos de telefonia/telegrafia;1;KG
8987;85181010;Piezeletricos proprios para aparelhos telefonicos;1;UN
8988;85181090;Outros microfones e seus suportes;1;UN
8989;85182100;Alto-falante (altifalante) unico montado no seu receptaculo;1;UN
8990;85182200;Alto-falantes (altifalantes) multiplos montados no mesmo receptaculo;1;UN
8991;85182910;Piezeletricos proprios para aparelhos telefonicos;1;UN
8992;85182990;Outros proprios para aparelhos telefonicos;1;UN
8993;85183000;Fones de ouvido, mesmo combinados com um microfone, e conjuntos ou sortidos constituidos por um microfone e um ou mais alto-falantes (altifalantes);1;UN
8994;85184000;Amplificadores eletricos de audiofrequencia;1;UN
8995;85185000;Aparelhos eletricos de amplificacao de som;1;UN
8996;85189010;Partes de alto-falantes;1;KG
8997;85189090;Partes de microfones, fones de ouvido, amplificadores, etc;1;KG
8998;85192000;Aparelhos que funcionem por introducao de moedas, papeis-moeda, cartoes de banco, fichas ou por outros meios de pagamento;1;UN
8999;85193000;Toca-discos sem dispositivos de amplificacao de som;1;UN
9000;85195000;Secretarias eletronicas;1;UN
9001;85198110;Aparelhos de reproducao de som, com sistema de leitura optica por laser (leitores de discos compactos);1;UN
9002;85198120;Gravadores de som de cabines de aeronaves;1;UN
9003;85198190;Outros gravadores de suporte magnetico, sem dispositivo de reproducao do som;1;UN
9004;85198900;Outros aparelhos de gravacao e de reproducao de som;1;UN
9005;85211010;Gravador-reprodutor de fita magnetica, sem sintonizador;1;UN
9006;85211081;Aparelhos videofonicos de gravacao ou de reproducao, em cassete, de largura de fita igual a 12,65 mm (1/2);1;UN
9007;85211089;Outros aparelhos videofonicos de gravacao ou de reproducao, em cassete, para fitas de largura inferior a 19,05 mm (3/4);1;UN
9008;85211090;Outros aparelhos videofonicos de gravacao ou de reproducao, em cassete, para fitas de largura superior ou igual a 19,05 mm (3/4);1;UN
9009;85219010;Gravador-reprodutor e editor de imagem e som, em discos, por meio magnetico, optico ou optomagnetico;1;UN
9010;85219090;Outros aparelhos videofonicos de gravacao/reproducao;1;UN
9011;85221000;Fonocaptores, para aparelhos de gravacao/reproducao;1;KG
9012;85229010;Agulhas com ponta de pedra preciosa, para aparelhos de reproducao;1;KG
9013;85229020;Gabinetes para aparelhos de gravacao/reproducao;1;KG
9014;85229030;Chassis ou suportes para aparelhos de gravacao/reproducao;1;KG
9015;85229040;Leitores de som, magneticos, para aparelhos de reproducao;1;KG
9016;85229050;Mecanismos toca-discos, mesmo com cambiador, para aparelhos de gravacao/reproducao;1;KG
9017;85229090;Outras partes e acessorios para aparelhos de gravacao/reproducao;1;KG
9018;85232110;Cartoes magneticos nao gravados;1;UN
9019;85232120;Cartoes magneticos gravados;1;UN
9020;85232911;Discos magneticos nao gravados, dos tipos utilizados em unidades de discos rigidos;1;UN
9021;85232919;Outros discos magneticos nao gravados;1;UN
9022;85232921;Fitas magneticas, nao gravadas, de largura nao superior a 4 mm, em cassetes;1;UN
9023;85232922;Fitas magneticas, nao gravadas, de largura superior a 4 mm mas inferior ou igual a 6,5 mm;1;UN
9024;85232923;Fitas magneticas, nao gravadas, de largura superior a 6,5 mm mas inferior ou igual a 50,8 mm (2), em rolos ou carreteis;1;UN
9025;85232924;Fitas magneticas, nao gravadas, de largura superior a 6,5 mm mas inferior ou igual a 50,8 mm (2), de largura superior a 6,5 mm, em cassetes para gravacao de video;1;UN
9026;85232929;Outras fitas magneticas nao gravadas;1;UN
9027;85232931;Fitas magneticas, gravadas, para reproducao de fenomenos diferentes do som ou da imagem;1;UN
9028;85232932;Fitas magneticas, gravadas, de largura nao superior a 4 mm, em cartuchos ou cassetes, exceto as do subitem 8523.29.31;1;UN
9029;85232933;Fitas magneticas, gravadas, de largura nao superior a 4 mm, de largura superior a 6,5 mm, exceto as do subitem 8523.29.31;1;UN
9030;85232939;Fitas magneticas, gravadas, de largura > 4 mm, e < 6,5 mm;1;UN
9031;85232990;Outros discos, fitas, suporte para gravacao de som, nao gravados;1;UN
9032;85234110;Discos para sistema de leitura por raios laser com possibilidade de serem gravados uma unica vez;1;UN
9033;85234190;Outros discos para sistema de leitura por raio laser;1;UN
9034;85234910;Discos para leitura por laser, para reproducao apenas do som;1;UN
9035;85234920;Discos para reproducao de fenomenos diferentes do som ou da imagem;1;UN
9036;85234990;Outros suportes opticos;1;UN
9037;85235110;Cartoes de memoria (memory cards);1;UN
9038;85235190;Outros dispositivos de armazenamento nao volatil de dados;1;UN
9039;85235200;Cartoes inteligentes;1;UN
9040;85235910;Cartoes e etiquetas de acionamento por aproximacao;1;UN
9041;85235990;Outros;1;UN
9042;85238000;Outros suportes preparados para gravacao de som/semelhantes;1;UN
9043;85255011;Aparelho de radiofusao em AM;1;UN
9044;85255012;Aparelho de radiodifusao em FM;1;UN
9045;85255019;Outros aparelhos de transmissao para radiodifusao;1;UN
9046;85255021;Aparelho de televisao, de frequencia superior a 7 GHz;1;UN
9047;85255022;Aparelho de televisao, em banda UHF, de frequencia superior ou igual a 2,0 GHz e inferior ou igual a 2,7 GHz, com potencia de saida superior ou igual a 10 W e inferior ou igual a 100 W;1;UN
9048;85255023;Aparelho de televisao, em banda UHF, com potencia de saida superior a 10 kW;1;UN
9049;85255024;Aparelho de televisao, em banda VHF, com potencia de saida superior ou igual a 20 kW;1;UN
9050;85255029;Outros aparelhos transmissores de televisao;1;UN
9051;85256010;Aparelhos transmissores (emissores) que incorporem um aparelho receptor, de radiodifusao;1;UN
9052;85256020;Aparelhos transmissores (emissores) que incorporem um aparelho receptor, de televisao, de frequencia superior a 7 GHz;1;UN
9053;85256090;Outros aparelhos transmissores com receptor de TV;1;UN
9054;85258011;Cameras de televisao, com tres ou mais captadores de imagem;1;UN
9055;85258012;Cameras de televisao, com sensor de imagem a semicondutor tipo CCD, de mais de 490 x 580 elementos de imagem (pixels) ativos, sensiveis a intensidades de iluminacao inferiores a 0,20 lux;1;UN
9056;85258013;Outras cameras de televisao, proprias para captar imagens exclusivamente no espectro infravermelho de comprimento de onda superior ou igual a 2 micrometros (microns) e inferior ou igual a 14 micrometros (microns);1;UN
9057;85258019;Outras cameras de televisao;1;UN
9058;85258021;Cameras fotograficas digitais e cameras de video, com tres ou mais captadores de imagem;1;UN
9059;85258022;Outras cameras fotograficas digitais e cameras de video, proprias para captar imagens exclusivamente no espectro infravermelho de comprimento de onda superior ou igual a 2 micrometros (microns) e inferior ou igual a 14 micrometros (microns);1;UN
9060;85258029;Outras cameras de video de imagens fixas;1;UN
9061;85261000;Aparelhos de radiodeteccao e de radiossondagem (radar);1;UN
9062;85269100;Aparelhos de radionavegacao;1;UN
9063;85269200;Aparelhos de radiotelecomando;1;UN
9064;85271200;Radios toca-fitas de bolso;1;UN
9065;85271300;Outros aparelhos combinados com aparelhos de gravacao ou reproducao do som;1;UN
9066;85271910;Aparelhos receptores de radio, combinado com  relogio, a pilha ou eletricidade;1;UN
9067;85271990;Outros aparelhos receptores de radiodifusao, a pilha/eletricos, etc;1;UN
9068;85272100;Aparelhos receptores de radiodifusao que so funcionem com fonte externa de energia, do tipo utilizado em veiculos automoveis, combinados com um aparelho de gravacao ou reproducao de som;1;UN
9069;85272900;Outros aparelhos receptores de radiodifusao, para veiculos automoveis, etc;1;UN
9070;85279100;Aparelhos receptores para radiodifusao, com aparelho de gravacao ou reproducao do som;1;UN
9071;85279200;Outros receptores nao combinados com aparelhos de gravacao/reproducao do som, mas combinados com relogio;1;UN
9072;85279910;Amplificador com sintonizador (receiver);1;UN
9073;85279990;Outros aparelhos recptores radiodifusao c/radiotel.-radioteleg.;1;UN
9074;85284210;Monitores com tubo de raios catodicos, capazes de serem conectados diretamente a uma maquina automatica para processamento de dados da posicao 84.71 e concebidos para serem utilizados com esta maquina, monocromaticos;1;UN
9075;85284220;Monitores com tubo de raios catodicos, capazes de serem conectados diretamente a uma maquina automatica para processamento de dados da posicao 84.71 e concebidos para serem utilizados com esta maquina, policromaticos;1;UN
9076;85284910;Monitores com tubo de raios catodicos, monocromaticos;1;UN
9077;85284921;Monitores de video, policromaticos, com dispositivos de selecao de varredura (underscanning) e de retardo de sincronismo horizontal e vertical (H/V delay ou pulse cross);1;UN
9078;85284929;Monitores com tubo de raios catodicos, policromaticos;1;UN
9079;85285210;Outros monitores, capazes de serem conectados diretamente a uma maquina automatica para processamento de dados da posicao 84.71 e concebidos para serem utilizados com esta maquina, monocromaticos;1;UN
9080;85285220;Outros monitores, capazes de serem conectados diretamente a uma maquina automatica para processamento de dados da posicao 84.71 e concebidos para serem utilizados com esta maquina, policromaticos;1;UN
9081;85285910;Outros monitores monocromaticos;1;UN
9082;85285920;Outros monitores policromaticos;1;UN
9083;85286200;Projetores, capazes de serem conectados diretamente a uma maquina automatica para processamento de dados da posicao 84.71 e concebidos para serem utilizados com esta maquina;1;UN
9084;85286910;Projetores, com tecnologia de dispositivo digital de microespelhos (DMD - Digital Micromirror Device);1;UN
9085;85286990;Outros projetores;1;UN
9086;85287111;Receptor-decodificador integrado (IRD) de sinais digitalizados de video codificados,sem saida de RF modulada nos canais 3 ou 4,com saidas de audio balanceadas com impedancia de 600 Ohms, proprio para montagem em racks e com saida de video com conector BNC;1;UN
9087;85287119;Outro receptor-decodificador integrado (IRD) de sinais digitalizados de video codificados;1;UN
9088;85287190;Outros aparelhos receptores de televisao, mesmo combinado, com outras cores;1;UN
9089;85287200;Outros aparelhos receptores de televisao, a cores (policromo);1;UN
9090;85287300;Outros aparelhos receptores de televisao, a preto e branco ou outros monocromos;1;UN
9091;85291011;Antenas com refletor parabolico, exceto para telefone celular;1;UN
9092;85291019;Outras antenas, exceto para telefones celulares;1;UN
9093;85291090;Outras antenas e refletores de antenas, e suas partes;1;KG
9094;85299011;Gabinetes e bastidores, de aparelhos transmissores e receptores;1;KG
9095;85299012;Circuitos impressos com componentes eletricos ou eletronicos, montados, para aparelhos transmissores e receptores;1;UN
9096;85299019;Outras partes para aparelhos transmissores/receptores;1;KG
9097;85299020;Outras partes para aparelhos receptores de radiodifusao, televisao, etc.;1;KG
9098;85299030;Outras partes para aparelhos de radiodeteccao e radiosondagem;1;KG
9099;85299040;Outras partes para aparelhos de radionavegacao;1;KG
9100;85299090;Outras partes para aparelhos de radiotelecomando/cameras de TV/video;1;KG
9101;85301010;Aparelhos eletronicos digitais para controle de trafego de vias ferreas;1;UN
9102;85301090;Outros aparelhos eletricos de sinalizacao, etc, para vias ferreas;1;UN
9103;85308010;Aparelhos eletronicos digitais para controle de trafego de automotores;1;UN
9104;85308090;Outros aparelhos eletricos de sinalizacao, etc, para vias terrestres, etc;1;UN
9105;85309000;Partes de aparelhos eletricos de sinalizacao, etc, para vias ferreas, etc;1;KG
9106;85311010;Alarmes contra incendio ou sobreaquecimento;1;UN
9107;85311090;Outros aparelhos eletricos de alarme, para protecao contra roubo;1;UN
9108;85312000;Paineis indicadores com dispositivos de cristais liquidos (LCD) ou de diodos emissores de luz (LED);1;UN
9109;85318000;Outros aparelhos eletricos de sinalizacao acustica/visual;1;UN
9110;85319000;Partes de aparelhos eletricos de sinalizacao acustica ou visual;1;KG
9111;85321000;Condensadores fixos concebidos para linhas eletricas de 50/60 Hz e capazes de absorver uma potencia reativa igual ou superior a 0,5 kvar (condensadores de potencia);1;UN
9112;85322111;Condensador fixo eletrico, de tantalo, proprios para montagem em superficie (SMD - Surface Mounted Device), com tensao de isolacao inferior ou igual a 125 V;1;UN
9113;85322119;Outros condensadores fixos eletricos, de tantalo, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9114;85322190;Outros condensadores fixos eletrolitico, de tantalo;1;UN
9115;85322200;Condensador fixo eletrolitico, de aluminio;1;UN
9116;85322310;Condensadores fixos com dieletrico de ceramica, de uma so camada, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9117;85322390;Outros condensadores fixos com dieletrico de ceramica, de uma so camada;1;UN
9118;85322410;Outros condensadores fixos, com dieletrico de ceramica, de camadas multiplas, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9119;85322490;Outros condensadores fixos, com dieletrico de ceramica, de camadas multiplas;1;UN
9120;85322510;Condensadores fixos com dieletrico de papel ou de plasticos, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9121;85322590;Outros condensadores fixos com dieletrico de papel ou de plasticos;1;UN
9122;85322910;Outros condensadores fixos eletricos para montagem em superficie;1;UN
9123;85322990;Outros condensadores fixos eletricos;1;UN
9124;85323010;Condensadores variaveis ou ajustaveis, proprios para montagem em superficie (SMD - Surface Mounted Device), eletricos;1;UN
9125;85323090;Outros condensadores variaveis ou ajustaveis, eletricos;1;UN
9126;85329000;Partes de condensadores eletricos fixos, variaveis ou ajustaveis;1;KG
9127;85331000;Resistencias eletricas fixas de carbono, aglomeradas ou de camada;1;UN
9128;85332110;Resistencias eletricas fixas, para potencia nao superior a 20 W, de fio;1;UN
9129;85332120;Resistencias eletricas fixas, para potencia nao superior a 20 W, para montagem em superficie;1;UN
9130;85332190;Outras resistencias eletricas fixas, para potencia nao superior a 20 W;1;UN
9131;85332900;Outras resistencias eletricas fixas;1;UN
9132;85333110;Potenciometros para potencia nao superior a 20 W;1;UN
9133;85333190;Outras resistencias eletricas variaveis bobinadas para potencia nao superior a 20 W;1;UN
9134;85333910;Outros potenciometros;1;UN
9135;85333990;Outras resistencias eletricas variaveis bobinadas;1;UN
9136;85334011;Termistores;1;UN
9137;85334012;Varistores;1;UN
9138;85334019;Outras resistencias eletricas variaveis, nao lineares semicondutoras;1;UN
9139;85334091;Potenciometro de carvao, do tipo dos utilizados para determinar o angulo de abertura da borboleta, em sistemas de injecao de combustivel controlados eletronicamente;1;UN
9140;85334092;Outros potenciometros de carvao;1;UN
9141;85334099;Outras resistencias eletricas variaveis;1;UN
9142;85339000;Partes de resistencias eletricas;1;KG
9143;85340011;Circuitos impressos, simples face, rigidos, com isolante de resina fenolica e papel celulosico;1;UN
9144;85340012;Circuitos impressos, simples face, rigidos, com isolante de resina epoxida e papel celulosico;1;UN
9145;85340013;Circuitos impressos, simples face, rigidos, com isolante de resina epoxida e tecido de fibra de vidro;1;UN
9146;85340019;Outros circuitos impressos, simples face, rigidos;1;UN
9147;85340020;Circuitos impressos, simples face, flexiveis;1;UN
9148;85340031;Circuitos impressos, dupla face, rigidos, com isolante de resina fenolica e papel celulosico;1;UN
9149;85340032;Circuitos impressos, dupla face, rigidos, com isolante de resina epoxida e papel celulosico;1;UN
9150;85340033;Circuitos impressos, dupla face, rigidos, com isolante de resina epoxida e tecido de fibra de vidro;1;UN
9151;85340039;Outros circuitos impressos, dupla face, rigidos;1;UN
9152;85340040;Circuitos impressos, dupla face, flexiveis;1;UN
9153;85340051;Circuitos impressos multicamadas, com isolante de resina epoxida e tecido de fibra de vidro;1;UN
9154;85340059;Outros circuitos impressos multicamadas;1;UN
9155;85351000;Fusiveis e corta-circuitos de fusiveis, para uma tensao superior a 1.000 V;1;UN
9156;85352100;Disjuntores, para uma tensao inferior a 72,5 kV;1;UN
9157;85352900;Outros disjuntores para tensao igual ou superior a 72,5 kv;1;UN
9158;85353013;Interruptores a vacuo, sem dispositivo de acionamento (ampolas a vacuo), para corrente nominal inferior ou igual a 1.600 A;1;UN
9159;85353017;Outros interruptores com dispositivo de acionamento nao automatico, para corrente nominal inferior ou igual a 1.600 A;1;UN
9160;85353018;Outros interruptores, com dispositivo de acionamento automatico, exceto os de contatos imersos em meio liquido;1;UN
9161;85353019;Outros seccionadores/interruptores, para uma tensao superior a 1.000 V, para corrente nominal inferior ou igual a 1.600 A;1;UN
9162;85353023;Interruptores a vacuo, sem dispositivo de acionamento (ampolas a vacuo), para corrente nominal superior a 1.600 A;1;UN
9163;85353027;Outros interruptores com dispositivo de acionamento nao automatico, para corrente nominal superior a 1.600 A;1;UN
9164;85353028;Outros interruptores, com dispositivo de acionamento automatico, exceto os de contatos imersos em meio liquido,  para corrente nominal superior a 1.600 A;1;UN
9165;85353029;Outros seccionadores/interruptores, para tensao > 1 Kv e corrente > 1600 A;1;UN
9166;85354010;Para-raios para protecao de linhas de transmissao de eletricidade, para uma tensao superior a 1.000 V;1;UN
9167;85354090;Limitadores de tensao e supressores de picos de tensao (supressores de sobretensoes), para uma tensao superior a 1.000 V;1;UN
9168;85359000;Outros aparelhos para interrupcao, etc, de circuitos eletricos, para uma tensao superior a 1.000 V;1;UN
9169;85361000;Fusiveis e corta-circuitos de fusiveis, para uma tensao nao superior a 1.000 V;1;UN
9170;85362000;Disjuntores, para uma tensao nao superior a 1.000 V;1;UN
9171;85363000;Outros aparelhos para protecao de circuitos eletricos, para uma tensao nao superior a 1.000 V;1;UN
9172;85364100;Reles para uma tensao nao superior a 60 V;1;UN
9173;85364900;Outros reles, para tensao maior que 60 Volts, mas menor que 1.000 Volts;1;UN
9174;85365010;Unidade chaveadora de conversor de subida e descida para sistema de telecomunicacoes via satelite, para uma tensao nao superior a 1.000 V;1;UN
9175;85365020;Unidade chaveadora de amplificador de alta potencia (HPA) para sistema de telecomunicacoes via satelite, para uma tensao nao superior a 1.000 V;1;UN
9176;85365030;Comutadores codificadores digitais, proprios para montagem em circuitos impressos;1;UN
9177;85365090;Outros interruptores, etc, de circuitos eletricos, para uma tensao nao superior a 1.000 V;1;UN
9178;85366100;Suportes para lampadas, para uma tensao nao superior a 1.000 V;1;UN
9179;85366910;Tomada polarizada e tomada blindada, para uma tensao nao superior a 1.000 V;1;UN
9180;85366990;Outras tomadas de corrente, para uma tensao nao superior a 1.000 V;1;UN
9181;85367000;Conectores para fibras opticas, feixes ou cabos de fibras opticas;1;UN
9182;85369010;Conectores para cabos planos constituidos por condutores paralelos isolados individualmente, para uma tensao nao superior a 1.000 V;1;UN
9183;85369020;Tomadas de contato deslizante em condutores aereos, para uma tensao nao superior a 1.000 V;1;UN
9184;85369030;Soquetes para microestruturas eletronicas, para uma tensao nao superior a 1.000 V;1;UN
9185;85369040;Conectores para circuito impresso, para uma tensao nao superior a 1.000 V;1;UN
9186;85369050;Terminais de conexao para capacitores, mesmo montados em suporte isolante, para uma tensao nao superior a 1.000 V;1;UN
9187;85369090;Outros aparelhos para interrupcao, etc, para circuitos eletricos, para uma tensao nao superior a 1.000 V;1;UN
9188;85371011;Comando numerico computadorizado (CNC),com processador e barramento >= 32 bits,incorporando recursos graficos e execucao de macros,resolucao <= 1 micrometro e capacidade de conexao digital para servo-acionamento, com monitor policromatico,tensao < 1.000 V;1;KG
9189;85371019;Outros quadros, paineis, etc, comando numerico computadorizado (CNC), para uma tensao nao superior a 1.000 V;1;KG
9190;85371020;Controladores programaveis, para uma tensao nao superior a 1.000 V;1;UN
9191;85371030;Controladores de demanda de energia eletrica, para uma tensao nao superior a 1.000 V;1;UN
9192;85371090;Outros quadros, etc, com aparelhos interruptores circuito eletrico, para uma tensao nao superior a 1.000 V;1;KG
9193;85372010;Subestacoes isoladas a gas (GIS - Gas-Insulated Switchgear ou HIS - Highly Integrated Switchgear), para uma tensao superior a 52 kV;1;KG
9194;85372090;Outros quadros, paineis, etc, com aparelho interruptor de circuito eletrico, para uma tensao superior a 1.000 V;1;KG
9195;85381000;Quadros, paineis, consoles, cabinas, armarios e outros suportes, da posicao 85.37, desprovidos dos seus aparelhos;1;KG
9196;85389010;Circuitos impressos com componentes eletricos ou eletronicos, montados, para aparelhos interruptores de circuito eletrico;1;UN
9197;85389020;Outras partes para aparelhos de interrupcao/protecao de circuito eletrico;1;UN
9198;85389090;Outras partes para aparelhos de interrupcao de circuito eletrico;1;KG
9199;85391010;Artigos denominados farois e projetores, em unidades seladas, para uma tensao inferior ou igual a 15 V;1;UN
9200;85391090;Outros artigos denominados farois e projetores, em unidades seladas;1;UN
9201;85392110;Outras lampadas e tubos de incandescencia, exceto de raios ultravioleta ou infravermelhos, halogenos, de tungstenio, para uma tensao inferior ou igual a 15 V;1;UN
9202;85392190;Outras lampadas/tubos incandescentes halogenos, de tungstenio;1;UN
9203;85392200;Outras lampadas/tubos incandescentes, de potencia nao superior a 200 W e uma tensao superior a 100 V;1;UN
9204;85392910;Outras lampadas/tubos incandescentes, para uma tensao inferior ou igual a 15 V;1;UN
9205;85392990;Outras lampadas/tubos incandescentes;1;UN
9206;85393100;Lampadas/tubos descarga, fluorescente, de catodo quente;1;UN
9207;85393200;Lampadas de vapor de mercurio/sodio ou halogeneto metal;1;UN
9208;85393900;Outras lampadas/tubos de descarga;1;UN
9209;85394110;Lampadas de arco, de potencia superior ou igual a 1.000 W;1;UN
9210;85394190;Outras lampadas de arco;1;UN
9211;85394900;Lampadas/tubos de raios ultravioleta ou infravermelhos;1;UN
9212;85395000;Lampadas e tubos de diodos emissores de luz (LED);1;UN
9213;85399010;Eletrodos para lampadas/tubos eletricos, de incandescencia, etc.;1;KG
9214;85399020;Bases para lampadas/tubos eletricos, de incandescencia, etc.;1;KG
9215;85399090;Outras partes para lampadas/tubos eletricos incandescencia, etc;1;KG
9216;85401100;Tubos catodicos para receptores de televisao, incluindo os tubos para monitores de videos, a cores (policromo);1;UN
9217;85401200;Tubos catodicos para receptores de televisao, incluindo os tubos para monitores de videos, a preto e branco ou outros monocromos;1;UN
9218;85402011;Tubos para cameras de televisao, em preto e branco ou outros monocromos;1;UN
9219;85402019;Outros tubos para cameras de televisao;1;UN
9220;85402020;Tubos conversores ou intensificadores de imagens, de raios X;1;UN
9221;85402090;Outros tubos conversores ou intensificadores de imagens, etc.;1;UN
9222;85404000;Tubos de visualizacao de dados graficos, em monocromos, tubos de visualizacao de dados graficos, a cores (policromo), com uma tela fosforica de espacamento entre os pontos inferior a 0,4 mm;1;UN
9223;85406010;Tubos de visualizacao de dados graficos, em cores, com uma tela de espacamento entre os pontos superior ou igual a 0,4 mm;1;UN
9224;85406090;Outros tubos catodicos;1;UN
9225;85407100;Tubos para microondas, magnetrons;1;UN
9226;85407900;Outros tubos para microondas;1;UN
9227;85408100;Tubos de recepcao ou de amplificacao;1;UN
9228;85408910;Valvulas de potencia para transmissores;1;UN
9229;85408990;Outras lampadas, tubos e valvulas, eletronicos, etc.;1;UN
9230;85409110;Bobinas de deflexao (yokes), para tubos catodicos;1;UN
9231;85409120;Nucleos de po ferromagnetico para bobinas de deflexao (yokes);1;UN
9232;85409130;Canhoes eletronicos para tubos catodicos;1;UN
9233;85409140;Painel de vidro, mascara de sombra e blindagem interna, reunidos, para tubos tricromaticos;1;UN
9234;85409190;Outras partes para tubos catodicos;1;KG
9235;85409900;Partes para lampadas, outros tubos e valvulas, eletronicos, etc.;1;KG
9236;85411011;Diodos nao montados, zener;1;UN
9237;85411012;Diodos nao montados, de intensidade de corrente<=3a;1;UN
9238;85411019;Outros diodos nao montados;1;UN
9239;85411021;Diodos zener montados, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9240;85411022;Diodos montados, proprios para montagem em superficie (SMD - Surface Mounted Device), de intensidade de corrente inferior ou igual a 3 A;1;UN
9241;85411029;Outros diodos montados para montagem em superficie (smd);1;UN
9242;85411091;Outros diodos zener;1;UN
9243;85411092;Outros diodos de intensidade de corrente <= 3 a;1;UN
9244;85411099;Outros diodos, exceto fotodiodos e diodos emissores de luz;1;UN
9245;85412110;Transistores, exceto os fototransistores, com capacidade de dissipacao inferior a 1 W, nao montados;1;UN
9246;85412120;Transistores, exceto os fototransistores, com capacidade de dissipacao inferior a 1 W, montados, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9247;85412191;Transistores com capacidade de dissipacao < 1 w, com juncao heterogenea;1;UN
9248;85412199;Outros transistores com capacidade de dissipacao < 1 w, exceto os fototransistores;1;UN
9249;85412910;Outros transistores, nao montados, exceto os fototransistores;1;UN
9250;85412920;Outros transistores, montados, exceto os fototransistores;1;UN
9251;85413011;Tiristores, diacs e triacs, exceto os dispositivos fotossensiveis, nao montados, de intensidade de corrente inferior ou igual a 3 A;1;UN
9252;85413019;Outros tiristores, diacs e triacs, exceto os dispositivos fotossensiveis, nao montados;1;UN
9253;85413021;Tiristores, diacs e triacs, exceto os dispositivos fotossensiveis, montados, de intensidade de corrente inferior ou igual a 3 A;1;UN
9254;85413029;Outros tiristores, diacs e triacs, exceto os dispositivos fotossensiveis, montados;1;UN
9255;85414011;Diodos emissores de luz (LED), exceto diodos laser, nao montados;1;UN
9256;85414012;Diodos laser nao montados;1;UN
9257;85414013;Fotodiodos nao montados;1;UN
9258;85414014;Fototransistores nao montados;1;UN
9259;85414015;Fototiristores nao montados;1;UN
9260;85414016;Celulas solares nao montadas;1;UN
9261;85414019;Outros dispositivos fotossensiveis semicondutores, nao montados;1;UN
9262;85414021;Diodos emissores de luz (led) montados, para montagem em superficie;1;UN
9263;85414022;Outros diodos emissores de luz (led) exceto diodos laser;1;UN
9264;85414023;Diodos laser com comprimento de onda de 1300 mm ou 1500 mm;1;UN
9265;85414024;Outros diodos laser;1;UN
9266;85414025;Fotodiodos, fototransistores e fototiristores, montados;1;UN
9267;85414026;Fotorresistores montados;1;UN
9268;85414027;Acopladores oticos, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9269;85414029;Outros dispositivos fotossensiveis semicondutores montados;1;UN
9270;85414031;Fotodiodos em modulos ou paineis;1;UN
9271;85414032;Celulas solares em modulos ou paineis;1;UN
9272;85414039;Outras celulas fotovoltaicas em modulos ou paineis;1;UN
9273;85415010;Outros dispositivos semicondutores nao montados;1;UN
9274;85415020;Outros dispositivos semicondutores montados;1;UN
9275;85416010;Cristais piezeletricos montados, de quartzo, de frequencia superior ou igual a 1 MHz, mas inferior ou igual a 100 MHz;1;UN
9276;85416090;Outros cristais piezoeletricos montados;1;UN
9277;85419010;Suportes-conectores apresentados em tiras (lead frames), diodos, etc.semicondutores;1;KG
9278;85419020;Coberturas para encapsulamento (capsulas);1;KG
9279;85419090;Outras partes de diodos, transistores, etc, semicondutores;1;KG
9280;85423110;Processadores e controladores, mesmo combinados com memorias, conversores, circuitos logicos, amplificadores, circuitos temporizadores e de sincronizacao, ou outros circuitos, nao montados;1;UN
9281;85423120;Processadores e controladores, mesmo combinados com memorias, conversores, circuitos logicos, amplificadores, circuitos temporizadores e de sincronizacao, ou outros circuitos, montados, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9282;85423190;Outros circuitos integrados;1;UN
9283;85423210;Memorias nao montadas;1;UN
9284;85423221;Memorias, montadas, proprias para montagem em superficie (SMD - Surface Mounted Device), dos tipos RAM estaticas (SRAM) com tempo de acesso inferior ou igual a 25 ns, EPROM, EEPROM, PROM, ROM e FLASH;1;UN
9285;85423229;Outras memorias digitais montadas;1;UN
9286;85423291;Outras memorias dos tipos RAM estaticas (SRAM) com tempo de acesso inferior ou igual a 25 ns, EPROM, EEPROM, PROM, ROM e FLASH;1;UN
9287;85423299;Outras memorias RAM com tempo de acesso inferior ou igual a 25 ns;1;UN
9288;85423311;Circuitos integrados eletronicos, amplificadores, hibridos, de espessura de camada inferior ou igual a 1 micrometro (micron) com frequencia de operacao superior ou igual a 800 MHz;1;UN
9289;85423319;Outros circuitos integrados eletronicos, amplificadores, hibridos;1;UN
9290;85423320;Outros circuitos integrados monoliticos, nao montados;1;UN
9291;85423390;Outros circuitos montados;1;UN
9292;85423911;Circuito integrado hibrido, de espessura de camada inferior ou igual a 1 micrometro (micron) com frequencia de operacao superior ou igual a 800 MHz;1;UN
9293;85423919;Outros circuitos integrados hibridos;1;UN
9294;85423920;Outros circuitos integrados monoliticos, nao montados;1;UN
9295;85423931;Circuitos do tipo chipset, montados, proprios para montagem em superficie (SMD - Surface Mounted Device);1;UN
9296;85423939;Outros circuitos integrados monoliticos;1;UN
9297;85423991;Outros circuitos integrados monoliticos chipset;1;UN
9298;85423999;Outros circuitos integrados monoliticos digitais;1;UN
9299;85429010;Suportes-conectores apresentados em tiras (lead frames);1;KG
9300;85429020;Coberturas para encapsulamento (capsulas);1;KG
9301;85429090;Outras partes para circuito integrado e microconjunto eletronico;1;KG
9302;85431000;Aceleradores de particulas;1;UN
9303;85432000;Geradores de sinais;1;UN
9304;85433000;Maquinas e aparelhos de galvanoplastia, eletrolise ou eletroforese;1;UN
9305;85437011;Amplificadores de radiofrequencia, para transmissao de sinais de micro-ondas de alta potencia (HPA), a valvula TWT do tipo Phase Combiner, com potencia de saida superior a 2,7 kW;1;UN
9306;85437012;Amplificadores de radiofrequencia, para recepcao de sinais de micro-ondas de baixo ruido (LNA) na banda de 3.600 a 4.200 MHz, com temperatura menor ou igual a 55 Kelvin, para telecomunicacoes via satelite;1;UN
9307;85437013;Amplificadores de radiofrequencia, para distribuicao de sinais de televisao;1;UN
9308;85437014;Outros amplificadores de radiofrequencia, para recepcao de sinais de micro-ondas;1;UN
9309;85437015;Outros amplificadores de radiofrequencia, para transmissao de sinais de micro-ondas;1;UN
9310;85437019;Outros amplificadores de radiofrequencia;1;UN
9311;85437020;Aparelhos para eletrocutar insetos;1;UN
9312;85437031;Geradores de efeitos especiais com manipulacao em 2 ou 3 dimensoes, mesmo combinados com dispositivo de comutacao, de mais de 10 entradas de audio ou de video;1;UN
9313;85437032;Geradores de caracteres, digitais;1;UN
9314;85437033;Sincronizadores de quadro armazenadores ou corretores de base de tempo;1;UN
9315;85437034;Controladores de edicao para video;1;UN
9316;85437035;Misturador digital, em tempo real, com oito ou mais entradas;1;UN
9317;85437036;Roteador-comutador (routing switcher) de mais de 20 entradas e mais de 16 saidas, de audio ou de video;1;UN
9318;85437039;Outras maquinas e aparelhos auxiliares para video;1;UN
9319;85437040;Transcodificadores ou conversores de padroes de televisao;1;UN
9320;85437050;Simulador de antenas para transmissores com potencia igual ou superior a 25 kW (carga fantasma);1;UN
9321;85437091;Terminais de texto que operem com codigo de transmissao Baudot, providos de teclado alfanumerico e visor, para acoplamento exclusivamente acustico a telefone;1;UN
9322;85437092;Eletrificadores de cercas;1;UN
9323;85437099;Outras maquinas e aparelhos eletricos com funcao propria;1;UN
9324;85439010;Partes das maquinas ou aparelhos da subposicao 8543.70;1;KG
9325;85439090;Partes de outras maquinas e aparelhos eletricos com funcao propria;1;KG
9326;85441100;Fios de cobre para bobinar, isolados para usos eletricos (incluindo os envernizados ou oxidados anodicamente);1;KG
9327;85441910;Fios de aluminio para bobinar, isolados para usos eletricos (incluindo os envernizados ou oxidados anodicamente);1;KG
9328;85441990;Outros fios para bobinar, isolados para usos eletricos (incluindo os envernizados ou oxidados anodicamente);1;KG
9329;85442000;Cabos coaxiais e outros condutores eletricos coaxiais;1;KG
9330;85443000;Jogos de fios para velas de ignicao e outros jogos de fios dos tipos utilizados em quaisquer veiculos;1;KG
9331;85444200;Outros condutores eletricos tensao <= 100 v, com pecas de conexao;1;KG
9332;85444900;Outros condutores eletricos para tensao <= 80 v;1;KG
9333;85446000;Outros condutores eletricos para tensao > 1000 v;1;KG
9334;85447010;Cabos de fibras opticas revestimento externo de material dieletrico;1;KG
9335;85447020;Cabos de fibras opticas revestimento externo de aco para instalacao submarina;1;KG
9336;85447030;Cabos de fibras opticas revestimento externo de aluminio;1;KG
9337;85447090;Outros cabos de fibras opticas;1;KG
9338;85451100;Eletrodos de carvao, dos tipos utilizados em fornos;1;KG
9339;85451910;Eletrodos de grafita, com teor de carbono superior ou igual a 99,9 %, em peso;1;KG
9340;85451920;Blocos de grafite, dos tipos utilizados como catodos em cubas eletroliticas;1;KG
9341;85451990;Outros eletrodos de carvao, para usos eletricos;1;KG
9342;85452000;Escovas de carvao, para usos eletricos;1;KG
9343;85459010;Carvoes para pilhas eletricas;1;KG
9344;85459020;Resistencias aquecedoras desprovidas de revestimento e de terminais;1;KG
9345;85459030;Suportes de conexao (nipples), para eletrodos;1;KG
9346;85459090;Outros carvoes e artigos de grafita/carvao para uso eletrico;1;KG
9347;85461000;Isoladores de vidro para uso eletrico;1;KG
9348;85462000;Isoladores de ceramica para uso eletrico;1;KG
9349;85469000;Isoladores de outras materias para uso eletrico;1;KG
9350;85471000;Pecas isolantes de ceramica, para maquinas, aparelhos e instalacoes eletricas;1;KG
9351;85472010;Tampoes vedadores para capacitores, com perfuracoes para terminais;1;KG
9352;85472090;Outras pecas isolantes de plastico para maquinas, aparelhos e instalacoes eletricas;1;KG
9353;85479000;Outras pecas/tubos isolantes para maquinas, aparelhos e instalacoes eletricas;1;KG
9354;85481010;Desperdicios/residuos de acumuladores eletricos de chumbo, etc;1;KG
9355;85481090;Desperdicios/residuos de pilhas/bateria, pilhas eletricas, etc;1;KG
9356;85489010;Termopares dos tipos utilizados em dispositivos termoeletricos de seguranca de aparelhos alimentados a gas;1;KG
9357;85489090;Partes eletricas de outras maquinas e aparelhos;1;KG
9358;86011000;Locomotivas e locotratores, de fonte externa de eletricidade;1;UN
9359;86012000;Locomotivas e locotratores, de acumuladores eletricos;1;UN
9360;86021000;Locomotivas diesel-eletricas;1;UN
9361;86029000;Outras locomotivas e locotratores, e tenderes;1;UN
9362;86031000;Litorinas, mesmo para circulacao urbana, exceto as da posicao 86.04, de fonte externa de eletricidade;1;UN
9363;86039000;Outras litorinas, mesmo para circulacao urbana, exceto as da posicao 86.04;1;UN
9364;86040010;Veiculos para inspecao e manutencao de vias ferreas ou semelhantes, autopropulsados, equipados com batedores de balastro e alinhadores de vias ferreas;1;UN
9365;86040090;Outros veiculos para inspecao e manutencao de vias ferreas ou semelhantes;1;UN
9366;86050010;Vagoes de passageiros para vias ferreas ou semelhantes (excluindo as viaturas da posicao 86.04);1;UN
9367;86050090;Furgoes para bagagem, vagoes-postais e outros vagoes especiais, para vias ferreas ou semelhantes (excluindo as viaturas da posicao 86.04).;1;UN
9368;86061000;Vagoes-tanques e semelhantes, para transporte de mercadorias sobre vias ferreas;1;UN
9369;86063000;Vagoes de descarga automatica, exceto os da subposicao 8606.10, para transporte de mercadorias sobre vias ferreas;1;UN
9370;86069100;Vagoes cobertos e fechados, para transporte de mercadorias sobre vias ferreas;1;UN
9371;86069200;Vagoes abertos, com paredes fixas de altura superior a 60 cm, para transporte de mercadorias sobre vias ferreas;1;UN
9372;86069900;Outros vagoes para transporte de mercadorias sobre vias ferreas;1;UN
9373;86071110;Bogies de tracao de veiculos para vias ferreas;1;KG
9374;86071120;Bissels de tracao de veiculos para vias ferreas/semelhantes;1;KG
9375;86071200;Outros bogies e bissels de veiculos para vias ferreas;1;KG
9376;86071911;Mancais com rolamentos incorporados, de diametro exterior superior a 190 mm, do tipo dos utilizados em eixos de rodas de vagoes ferroviarios;1;KG
9377;86071919;Outros mancais de veiculos para vias ferreas;1;KG
9378;86071990;Eixos, rodas e suas partes de veiculos para vias ferreas;1;KG
9379;86072100;Freios a ar comprimido e suas partes, de veiculos para vias ferreas;1;KG
9380;86072900;Outros freios e suas partes, de veiculos para vias ferreas;1;KG
9381;86073000;Ganchos e outros sistemas de engate, para-choques, e suas partes, de veiculos para vias ferreas;1;KG
9382;86079100;Outras partes de locomotivas ou de locotratores;1;KG
9383;86079900;Outras partes de veiculos para vias ferreas;1;KG
9384;86080011;Aparelhos mecanicos de sinalizacao, de seguranca, de controle ou de comando para vias ferreas ou semelhantes, rodoviarias ou fluviais, para areas ou parques de estacionamento, instalacoes portuarias ou para aerodromos;1;KG
9385;86080012;Aparelhos eletromecanicos de sinalizacao, de seguranca, de controle ou de comando para vias ferreas ou semelhantes, rodoviarias ou fluviais, para areas ou parques de estacionamento, instalacoes portuarias ou para aerodromos;1;KG
9386;86080090;Material fixo de vias ferreas ou semelhantes, suas partes;1;KG
9387;86090000;Conteineres, incluindo os de transporte de fluidos, especialmente concebidos e equipados para um ou varios meios de transporte;1;UN
9388;87011000;Tratores motocultores;1;UN
9389;87012000;Tratores rodoviarios para semi-reboques;1;UN
9390;87013000;Tratores de lagartas;1;UN
9391;87019100;Outros tratores, com uma potencia de motor nao superior a 18 kW;1;UN
9392;87019200;Outros tratores, com uma potencia de motor superior a 18 kW, mas nao superior a 37 kW;1;UN
9393;87019300;Outros tratores, com uma potencia de motor superior a 37 kW, mas nao superior a 75 kW;1;UN
9394;87019410;Tratores especialmente concebidos para arrastar troncos (log skidders), com uma potencia de motor superior a 75 kW, mas nao superior a 130 kW;1;UN
9395;87019490;Outros tratores, com uma potencia de motor superior a 75 kW, mas nao superior a 130 kW;1;UN
9396;87019510;Tratores especialmente concebidos para arrastar troncos (log skidders), com uma potencia de motor superior a 130 Kw;1;UN
9397;87019590;Outros tratores, com uma potencia de motor superior a 130 Kw;1;UN
9398;87021000;Veiculos automoveis para transporte de dez pessoas ou mais, incluindo o motorista, com motor de pistao, de ignicao por compressao (diesel ou semidiesel);1;UN
9399;87022000;Veiculos automoveis para transporte de dez pessoas ou mais, incluindo o motorista, equipados para propulsao, simultaneamente, com um motor de pistao de ignicao por compressao (diesel ou semidiesel) e um motor eletrico;1;UN
9400;87023000;Veiculos automoveis para transporte de dez pessoas ou mais, incluindo o motorista, equipados para propulsao, simultaneamente, com um motor de pistao alternativo de ignicao por centelha (faisca) e um motor eletrico;1;UN
9401;87024010;Trolebus;1;UN
9402;87024090;Outros veiculos automoveis para transporte de dez pessoas ou mais, incluindo o motorista, unicamente com motor eletrico para propulsao;1;UN
9403;87029000;Outros veiculos automoveis para transporte de dez pessoas ou mais, incluindo o motorista;1;UN
9404;87031000;Veiculos especialmente concebidos para se deslocar sobre a neve, veiculos especiais para transporte de pessoas nos campos de golfe e veiculos semelhantes;1;UN
9405;87032100;Automoveis com motor explosao, de cilindrada nao superior a 1.000 cm3;1;UN
9406;87032210;Automoveis com motor explosao, de cilindrada superior a 1.000 cm3, mas nao superior a 1.500 cm3, com capacidade de transporte de pessoas sentadas inferior ou igual a seis, incluindo o motorista;1;UN
9407;87032290;Automoveis com motor explosao, de cilindrada superior a 1.000 cm3, mas nao superior a 1.500 cm3, superior a 6 passageiros;1;UN
9408;87032310;Automoveis com motor explosao, 1500 < cm3 <= 3000, ate 6 passageiros;1;UN
9409;87032390;Automoveis com motor explosao, 1500 < cm3 <=3000, superior a 6 passageiros;1;UN
9410;87032410;Automoveis com motor explosao, cm3 > 3000, ate 6 passageiros;1;UN
9411;87032490;Automoveis com motor explosao, cm3 > 3000, superior a 6 passageiros;1;UN
9412;87033110;Automoveis com motor diesel, cm3 <= 1500, ate 6 passageiros;1;UN
9413;87033190;Automoveis com motor diesel, cm3 <= 1500, superior a 6 passageiros;1;UN
9414;87033210;Automoveis com motor diesel, 1500 < cm3 <= 2500, ate 6 passageiros;1;UN
9415;87033290;Automoveis com motor diesel, 1500 < cm3 <= 2500, superior a 6 passageiros;1;UN
9416;87033310;Automoveis com motor diesel, cm3 > 2500, ate 6 passageiros;1;UN
9417;87033390;Automoveis com motor diesel, cm3 > 2500, superior a 6 passageiros;1;UN
9418;87034000;Outros veiculos, equipados para propulsao, simultaneamente, com um motor de pistao alternativo de ignicao por centelha (faisca) e um motor eletrico, exceto os suscetiveis de serem carregados por conexao a uma fonte externa de energia eletrica;1;UN
9419;87035000;Outros veiculos, equipados para propulsao, simultaneamente, com um motor de pistao de ignicao por compressao (diesel ou semidiesel) e um motor eletrico, exceto os suscetiveis de serem carregados por conexao a uma fonte externa de energia eletrica;1;UN
9420;87036000;Outros veiculos, equipados para propulsao, simultaneamente, com um motor de pistao alternativo de ignicao por centelha (faisca) e um motor eletrico, suscetiveis de serem carregados por conexao a uma fonte externa de energia eletrica;1;UN
9421;87037000;Outros veiculos, equipados para propulsao, simultaneamente, com um motor de pistao de ignicao por compressao (diesel ou semidiesel) e um motor eletrico, suscetiveis de serem carregados por conexao a uma fonte externa de energia eletrica;1;UN
9422;87038000;Outros veiculos, equipados unicamente com motor eletrico para propulsao;1;UN
9423;87039000;Outros automoveis de passageiros, inclusive de uso misto, etc.;1;UN
9424;87041010;Dumpers para transporte de mercadoria >= 85 toneladas, utilizado fora de rodovias;1;UN
9425;87041090;Outros dumpers para transporte de mercadoria, utilizado fora de rodovias;1;UN
9426;87042110;Chassis com motor diesel e cabina, para carga <= 5 toneladas;1;UN
9427;87042120;Veiculo automovel com motor diesel, caixa basculante para carga <= 5 toneladas;1;UN
9428;87042130;Veiculos automoveis frigorificos, etc, com motor diesel, carga <= 5 toneladas;1;UN
9429;87042190;Outros veiculos automoveis com motor diesel, para carga <= 5 toneladas;1;UN
9430;87042210;Chassis com motor diesel e cabina, 5 toneladas < carga <= 20 toneladas;1;UN
9431;87042220;Veiculo automovel com motor diesel, caixa basculante 5 toneladas < carga <= 20 toneladas;1;UN
9432;87042230;Veiculos automoveis frigorificos, etc, com motor diesel, 5 toneladas < carga <= 20 toneladas;1;UN
9433;87042290;Outros veiculos automoveis com motor diesel, capacidade de carga entre 5 e 20 toneladas;1;UN
9434;87042310;Chassis com motor diesel e cabina, capacidade de carga > 20 toneladas;1;UN
9435;87042320;Veiculos automoveis com motor diesel, caixa bascular, carga > 20 toneladas;1;UN
9436;87042330;Veiculos automoveis frigorificos com motor diesel, capacidade de carga maior que 20 toneladas;1;UN
9437;87042390;Outros veiculos automoveis motor diesel, carga > 20 toneladas;1;UN
9438;87043110;Chassis com motor a explosao e cabina, de peso em carga maxima nao superior a 5 toneladas;1;UN
9439;87043120;Veiculos automoveis com motor a explosao/caixa basculante, de peso em carga maxima nao superior a 5 toneladas;1;UN
9440;87043130;Veiculos automoveis frigorificos ou isotermicos, etc, com motor a explosao, de peso em carga maxima nao superior a 5 toneladas;1;UN
9441;87043190;Outros veiculos automoveis com motor a explosao, carga <= 5 toneladas;1;UN
9442;87043210;Chassis com motor explosao e cabina, carga >5 toneladas;1;UN
9443;87043220;Veiculos automoveis com motor a explosao/caixa basculante capacidade de carga > 5 toneladas;1;UN
9444;87043230;Veiculos automoveis frigorificos, etc, com motor a explosao, carga > 5 toneladas;1;UN
9445;87043290;Outros veiculos automoveis com motor a explosao, carga > 5 toneladas;1;UN
9446;87049000;Outros veiculos automoveis para transporte de mercadorias;1;UN
9447;87051010;Caminhoes-guindastes capacidade maxima de elevacao >= 60 toneladas, haste telescopica;1;UN
9448;87051090;Outros caminhoes-guindastes;1;UN
9449;87052000;Torres (derricks) automoveis, para sondagem/perfuracao;1;UN
9450;87053000;Veiculos automoveis de combate a incendios;1;UN
9451;87054000;Caminhoes-betoneiras;1;UN
9452;87059010;Caminhoes para perfilagem de pocos petroliferos;1;UN
9453;87059090;Outros veiculos automoveis para usos especiais;1;UN
9454;87060010;Chassis com motor para veiculos automoveis transporte pessoas >= 10;1;UN
9455;87060020;Chassis com motor para dumpers e tratores, exceto rodoviarios;1;UN
9456;87060090;Outros chassis com motor, para automoveis de passageiros/mercadorias;1;UN
9457;87071000;Carrocerias para automoveis de passageiros, inclusive as cabinas;1;UN
9458;87079010;Carrocerias pata dumpers/tratores, exceto rodoviario, inclusive cabina;1;UN
9459;87079090;Carrocerias para veiculos automoveis com capacidade de transporte => 10 pessoas, ou para carga;1;UN
9460;87081000;Para-choques e suas partes para veiculos automoveis;1;UN
9461;87082100;Cintos de seguranca para veiculos automoveis;1;UN
9462;87082911;Para-lamas para dumpers e tratores, exceto os rodoviarios;1;UN
9463;87082912;Grades de radiadores para dumpers/tratores, exceto de uso rodoviario;1;UN
9464;87082913;Portas para dumpers e tratores exceto os rodoviarios;1;UN
9465;87082914;Paineis de instrumentos para dumpers/tratores, exceto rodoviario;1;UN
9466;87082919;Outras partes/acessorios de carrocerias para dumpers e tratores;1;UN
9467;87082991;Para-lamas para veiculos automoveis;1;UN
9468;87082992;Grades de radiadores para veiculos automoveis;1;UN
9469;87082993;Portas para veiculos automoveis;1;UN
9470;87082994;Paineis de instrumentos para veiculos automoveis;1;UN
9471;87082995;Inflador de bolsa de ar, para dispositivo de seguranca para automoveis;1;UN
9472;87082999;Outras partes e acessorios de carrocerias para veiculos automoveis;1;UN
9473;87083011;Guarnicoes de freios, montadas, para tratores e dumpers;1;UN
9474;87083019;Guarnicoes de freios, montadas, para veiculos automoveis;1;UN
9475;87083090;Outros freios e partes, para tratores/veiculos automoveis;1;UN
9476;87084011;Servo-assistidas, proprias para torques de entrada superiores ou iguais a 750 Nm, de tratores/dumpers;1;UN
9477;87084019;Outras caixas de marchas para tratores ou dumpers;1;UN
9478;87084080;Outras caixas de marchas;1;UN
9479;87084090;Partes de caixas de marchas;1;UN
9480;87085011;Eixos com diferencial com capacidade de suportar cargas superiores ou iguais a 14.000 kg, redutores planetarios nos extremos e dispositivo de freio incorporado, do tipo dos utilizados em veiculos da subposicao 8704.10;1;UN
9481;87085012;Eixos e partes, exceto de transmissao, para tratores/dumpers;1;UN
9482;87085019;Eixos de transmissao com diferencial para dumpers/tratores;1;UN
9483;87085080;Eixos de transmissao com diferencial para veiculos automoveis;1;UN
9484;87085091;Eixos e partes, exceto de transmissao, para tratores/dumpers;1;UN
9485;87085099;Outros eixos e partes, para veiculos automoveis;1;KG
9486;87087010;Rodas de eixos propulsor, suas partes, para dumpers/tratores;1;UN
9487;87087090;Outras rodas, suas partes e acessorios, para veiculos automoveis;1;UN
9488;87088000;Amortecedores de suspensao para tratores e veiculos automoveis;1;UN
9489;87089100;Radiadores para tratores e veiculos automoveis;1;UN
9490;87089200;Silenciosos e tubos de escape para tratores/veiculos automoveis;1;UN
9491;87089300;Embreagens e suas partes para tratores/veiculos automoveis;1;UN
9492;87089411;Volante de direcao para dumpers e tratores, exceto rodoviario;1;UN
9493;87089412;Barra de direcao para dumpers e tratores, exceto rodoviarios;1;UN
9494;87089413;Caixa de direcao para dumpers e tratores, exceto rodoviarios;1;UN
9495;87089481;Volantes de direcao para veiculos automoveis;1;UN
9496;87089482;Barras de direcao para veiculos automoveis;1;UN
9497;87089483;Caixas de direcao para veiculos automoveis;1;UN
9498;87089490;Outras partes, acessorios para tratores e veiculos automoveis;1;KG
9499;87089510;Bolsas inflaveis de seguranca com sistema de insuflacao (airbags);1;UN
9500;87089521;Bolsas inflaveis para airbags;1;UN
9501;87089522;Sistema de insuflacao, para dispositivo de seguranca para automoveis (airbag);1;UN
9502;87089529;Outras partes e acessorios de carrocerias para veiculos automoveis;1;UN
9503;87089910;Dispositivo para comando, acelerador, freio, etc, para veiculo automovel;1;KG
9504;87089990;Outras partes e acessorios para tratores e veiculos automoveis;1;KG
9505;87091100;Veiculos automoveis eletricos, sem dispositivo de elevacao, utilizados em fabricas, etc.;1;UN
9506;87091900;Outros veiculos automoveis, sem dispositivo de elevacao, utilizados em fabricas, etc.;1;UN
9507;87099000;Partes de veiculos automoveis sem dispositivo de elevacao, utilizado em fabricas;1;KG
9508;87100000;Veiculos e carros blindados de combate, armados ou nao, e suas partes;1;UN
9509;87111000;Motocicletas (incluindo os ciclomotores) e outros ciclos, com motor a pistao alternativo, com motor de pistao alternativo de cilindrada nao superior a 50 cm3;1;UN
9510;87112010;Motocicletas com motor a pistao alternativo, de cilindrada inferior ou igual a 125 cm3;1;UN
9511;87112020;Motocicletas com motor a pistao alternativo, de cilindrada superior a 125 cm3;1;UN
9512;87112090;Outros ciclos com motor a pistao alternativo, 50 cm3 < cilindrada <= 250 cm3;1;UN
9513;87113000;Motocicletas, etc, com motor a pistao alternativo, 250 < cilindrada <= 500 cm3;1;UN
9514;87114000;Motocicletas, etc, com motor a pistao alternativo, 500 < cilindrada <= 800 cm3;1;UN
9515;87115000;Motocicletas, etc, com motor a pistao alternativo, cilindrada > 800 cm3;1;UN
9516;87116000;Motocicletas (incluindo os ciclomotores) e outros ciclos equipados com motor auxiliar, mesmo com carro lateral, com motor eletrico para propulsao;1;UN
9517;87119000;Outras motocicletas/ciclos, com motor auxiliar, carros laterais;1;UN
9518;87120010;Bicicletas sem motor;1;UN
9519;87120090;Outros ciclos sem motor, inclusive triciclos;1;UN
9520;87131000;Cadeiras de rodas, etc, sem mecanismo de propulsao;1;UN
9521;87139000;Outras cadeiras de rodas e outras veiculos para invalidos;1;UN
9522;87141000;Partes e acessorios de motocicletas (inclusive ciclomotores);1;KG
9523;87142000;Partes e acessorios para cadeiras de rodas/outros veiculos para invalidos;1;KG
9524;87149100;Quadros, garfos e suas partes, para bicicletas e outros ciclos;1;KG
9525;87149200;Aros e raios para bicicletas e outros ciclos;1;KG
9526;87149310;Cubos, exceto de freios (travoes) para bicibletas e outros ciclos;1;KG
9527;87149320;Pinhoes de rodas livres para bicibletas e outros ciclos;1;KG
9528;87149410;Cubos de freios para bicicletas e outros ciclos;1;KG
9529;87149490;Outros freios e suas partes para bicicletas e outros ciclos;1;KG
9530;87149500;Selins de bicicletas e outros ciclos;1;UN
9531;87149600;Outras partes e acessorios para bicicletas e outros ciclos;1;KG
9532;87149910;Cambio de velocidades para bicicletas e outros ciclos;1;KG
9533;87149990;Outras partes e acessorios para bicicletas e outros ciclos;1;KG
9534;87150000;Carrinhos e veiculos semelhantes para transporte de criancas, e suas partes;1;KG
9535;87161000;Reboques/semi-reboques para habitacao/acampar trailer;1;UN
9536;87162000;Reboques/semi-reboques autocarregaveis, etc, para uso agricola;1;UN
9537;87163100;Reboques-cisternas para transporte de mercadorias;1;UN
9538;87163900;Outros reboques e semi-reboques para transporte de mercadorias;1;UN
9539;87164000;Outros reboques e semi-reboques;1;UN
9540;87168000;Outros veiculos nao autopropulsores;1;UN
9541;87169010;Chassis de reboques e semi-reboques;1;UN
9542;87169090;Outras partes de reboques/semi-reboques/veiculos nao autopropulsados;1;KG
9543;88010000;Baloes e dirigiveis, planadores, asas voadoras e outros veiculos aereos, nao concebidos para propulsao a motor;1;UN
9544;88021100;Helicopteros, de peso nao superior a 2.000 kg, vazios;1;UN
9545;88021210;Helicopteros, de peso inferior ou igual a 3.500 kg;1;UN
9546;88021290;Helicopteros, de peso maior que 3500 kg, vazios;1;UN
9547;88022010;Avioes e outros veiculos aereos, a helice, de peso nao superior a 2.000 kg, vazios;1;UN
9548;88022021;Avioes e outros veiculos aereos, a turboelice, de peso nao superior a 2.000 kg, vazios, monomotores;1;UN
9549;88022022;Avioes e outros veiculos aereos, de peso nao superior a 2.000 kg, vazios, a turboelice, multimotores;1;UN
9550;88022090;Outros avioes e veiculos aereos, de peso menor ou igual a 2000 kg, vazios;1;UN
9551;88023010;Avioes e outros veiculos aereos, a helice, de peso superior a 2.000 kg, mas nao superior a 15.000 kg, vazios;1;UN
9552;88023021;Avioes e outros veiculos aereos, a turboelice, multimotores, de peso inferior ou igual a 7.000 kg, vazios;1;UN
9553;88023029;Avioes e outros veiculos aereos, 7 toneladas < peso <= 15 toneladas, vazios, a turboelice;1;UN
9554;88023031;Avioes e outros veiculos aereos, a turbojato, de peso inferior ou igual a 7.000 kg, vazios;1;UN
9555;88023039;Avioes e outros veiculos aereos, a turbojato, 7000 kg < peso <= 15000 kg, vazios;1;UN
9556;88023090;Outros avioes/veiculos aereos, 2000 kg < peso <= 15000 kg, vazios;1;UN
9557;88024010;Avioes e outros veiculos aereos, a turboelice, de peso superior a 15.000 kg, vazios;1;UN
9558;88024090;Outros avioes e outros veiculos aereos, de peso superior a 15.000 kg, vazios;1;UN
9559;88026000;Veiculos espaciais (incluindo os satelites) e seus veiculos de lancamento, e veiculos suborbitais;1;UN
9560;88031000;Helices e rotores, e suas partes, para veiculos aereos, etc.;1;KG
9561;88032000;Trens de aterrissagem e suas partes, para veiculos aereos, etc.;1;KG
9562;88033000;Outras partes de avioes ou de helicopteros;1;KG
9563;88039000;Outras partes para veiculos aereos/espaciais;1;KG
9564;88040000;Para-quedas (incluindo os para-quedas dirigiveis e os parapentes) e os para-quedas giratorios, suas partes e acessorios;1;KG
9565;88051000;Aparelhos e dispositivos para lancamento de veiculos aereos, e suas partes, aparelhos e dispositivos para aterrissagem de veiculos aereos em porta-avioes e aparelhos e dispositivos semelhantes, e suas partes;1;KG
9566;88052100;Simuladores de combate aereo e suas partes;1;KG
9567;88052900;Outros aparelhos de treinamento de voo em terra e suas partes;1;KG
9568;89011000;Transatlanticos, barcos de excursao e embarcacoes semelhantes principalmente concebidas para o transporte de pessoas, ferryboats;1;UN
9569;89012000;Navios-tanque;1;UN
9570;89013000;Barcos frigorificos, exceto os da subposicao 8901.20 (navios-tanque);1;UN
9571;89019000;Outras embarcacoes para o transporte de mercadorias ou para o transporte de pessoas e de mercadorias;1;UN
9572;89020010;Barcos de pesca, navios-fabricas e outras embarcacoes para o tratamento ou conservacao de produtos da pesca, de comprimento, de proa a popa, superior ou igual a 35 m;1;UN
9573;89020090;Outros barcos de pesca, navios-fabricas e outras embarcacoes para o tratamento ou conservacao de produtos da pesca;1;UN
9574;89031000;Barcos inflaveis;1;UN
9575;89039100;Barcos a vela, mesmo com motor auxiliar;1;UN
9576;89039200;Barcos a motor, exceto com motor fora-de-borda;1;UN
9577;89039900;Outros barcos/embarcacoes de recreio/esporte, inclusive canoas;1;UN
9578;89040000;Rebocadores e barcos concebidos para empurrar outras embarcacoes;1;UN
9579;89051000;Dragas;1;UN
9580;89052000;Plataformas de perfuracao ou de exploracao, flutuantes ou submersiveis;1;UN
9581;89059000;Barcos-farois/guindastes/docas/diques flutuantes, etc.;1;UN
9582;89061000;Navios de guerra;1;UN
9583;89069000;Outras embarcacoes, inclusive barco salva-vidas, exceto os barcos a remos;1;UN
9584;89071000;Balsas inflaveis;1;UN
9585;89079000;Outras estruturas flutuantes (por exemplo, reservatorios, caixoes, boias de amarracao, boias de sinalizacao e semelhantes);1;UN
9586;89080000;Embarcacoes e outras estruturas flutuantes, a serem desmanteladas;1;UN
9587;90011011;Fibras opticas, com diametro de nucleo inferior a 11 micrometros (microns);1;KG
9588;90011019;Outras fibras opticas;1;KG
9589;90011020;Feixes e cabos de fibras opticas;1;KG
9590;90012000;Materias polarizantes, em folhas ou em placas;1;KG
9591;90013000;Lentes de contato;1;UN
9592;90014000;Lentes de vidro, para oculos;1;UN
9593;90015000;Lentes de outras materias, para oculos;1;UN
9594;90019010;Outras lentes nao montadas;1;KG
9595;90019090;Prismas, espelhos e outros elementos de optica, nao montados;1;KG
9596;90021110;Lentes objetivas montadas, para cameras fotograficas ou cinematograficas ou para projetores;1;UN
9597;90021120;Lentes objetivas montadas, de aproximacao (zoom) para cameras de televisao, de 20 ou mais aumentos;1;UN
9598;90021190;Outras lentes objetivas montadas, para cameras, aparelhos fotograficos;1;UN
9599;90021900;Outras lentes objetivas montadas;1;UN
9600;90022010;Filtros polarizantes, montados;1;KG
9601;90022090;Outros filtros opticos, montados;1;KG
9602;90029000;Outras lentes, prismas e elementos de optica, montados;1;KG
9603;90031100;Armacoes de plasticos, para oculos;1;UN
9604;90031910;Armacoes de metais comuns, para oculos, mesmo folheado, etc.;1;UN
9605;90031990;Armacoes de outras materias, para oculos;1;UN
9606;90039010;Charneiras para armacoes de oculos;1;KG
9607;90039090;Outras partes para armacoes de oculos e artigos semelhantes;1;KG
9608;90041000;Oculos de sol;1;UN
9609;90049010;Oculos para correcao;1;UN
9610;90049020;Oculos de seguranca;1;UN
9611;90049090;Outros oculos para protecao ou outros fins e artigos semelhantes;1;UN
9612;90051000;Binoculos;1;UN
9613;90058000;Lunetas e outros instrumentos de astronomia, suas armacoes;1;UN
9614;90059010;Partes e acessorios de binoculos;1;KG
9615;90059090;Partes e acessorios de lunetas e outros instrumentos de astronomia;1;KG
9616;90063000;Cameras fotograficas especialmente concebidas para fotografia submarina ou aerea, para exame medico de orgaos internos ou para laboratorios de medicina legal ou de investigacao judicial;1;UN
9617;90064000;Cameras fotograficas para filmes de revelacao e copiagem instantaneas;1;UN
9618;90065100;Outras cameras fotograficas, com visor de reflexao atraves da objetiva (reflex), para filmes em rolos de largura nao superior a 35 mm;1;UN
9619;90065200;Outros aparelhos fotograficos, para filmes, em rolos, largura < 35 mm;1;UN
9620;90065310;Aparelhos fotograficos de foco fixo, para filmes, em rolos, largura=35 mm;1;UN
9621;90065320;Aparelhos fotograficos de foco ajustavel, para filmes, em rolos, largura=35 mm;1;UN
9622;90065930;Fotocompositoras a laser para preparacao de cliches;1;UN
9623;90065940;Outras cameras fotograficas, de foco fixo;1;UN
9624;90065951;Outras cameras fotograficas, de foco ajustavel, para obtencao de negativos de 45 mm x 60 mm ou de dimensoes superiores;1;UN
9625;90065959;Outras cameras fotograficas de foco ajustavel;1;UN
9626;90066100;Aparelhos de tubo de descarga para producao de luz-relampago (denominados flashes eletronicos);1;UN
9627;90066900;Outros aparelhos e dispositivos para fotografia;1;UN
9628;90069110;Corpos para aparelhos fotograficos;1;KG
9629;90069190;Outras partes e acessorios para aparelhos fotograficos;1;KG
9630;90069900;Outras partes e acessorios para parelhos e dispositivos para fotografia;1;KG
9631;90071000;Cameras;1;UN
9632;90072020;Projetores para filmes, largura >= 35 mm, mas <= 70 mm;1;UN
9633;90072090;Outros projetores cinematograficos;1;UN
9634;90079100;Partes e acessorios para cameras cinematograficas;1;KG
9635;90079200;Partes e acessprios para projetores cinematograficos;1;KG
9636;90085000;Projetores e aparelhos de ampliacao ou reducao;1;UN
9637;90089000;Partes e acessorios para aparelhos de projecao fixa, etc.;1;KG
9638;90101010;Cubas e cubetas, de operacao automatica e programaveis, para revelacao de filmes;1;UN
9639;90101020;Ampliadoras-copiadoras automaticas para papel fotografico, com capacidade superior a 1.000 copias por hora;1;UN
9640;90101090;Outros aparelhos e materiais para revelacao automatica de filmes de fotografia, etc;1;UN
9641;90105010;Processadores fotograficos para o tratamento eletronico de imagens, mesmo com saida digital;1;UN
9642;90105020;Aparelhos para revelacao automatica de chapas de fotopolimeros com suporte metalico;1;UN
9643;90105090;Outros aparelhos e materiais para laboratorio fotografico, cinematografico, etc;1;UN
9644;90106000;Telas para projecao fotografica/cinematografica;1;UN
9645;90109010;Partes e acessorios para aparelhos de revelacao automatica pelicula fotografica, etc;1;KG
9646;90109090;Partes e acessorios para outros aparelhos utilizados em laboratorios fotograficos, etc;1;KG
9647;90111000;Microscopios opticos estereoscopicos;1;UN
9648;90112010;Microscopios para fotomicrografia;1;UN
9649;90112020;Microscopios para cinefotomicrografia;1;UN
9650;90112030;Microscopios para microprojecao;1;UN
9651;90118010;Microscopios opticos binoculares de platina movel;1;UN
9652;90118090;Outros microscopios opticos;1;UN
9653;90119010;Partes e acessorios para microscopios para fotomicrografia, etc.;1;KG
9654;90119090;Partes e acessorios para microscopios opticos;1;KG
9655;90121010;Microscopios eletronicos;1;UN
9656;90121090;Outros microscopios e difratografos;1;UN
9657;90129010;Partes e acessorios para microscopios eletronicos;1;KG
9658;90129090;Partes e acessorios para outros microscopios e difratografos;1;KG
9659;90131010;Miras telescopicas para armas;1;UN
9660;90131090;Periscopios, lunetas para maquinas, aparelhos e instrumentos opticos;1;UN
9661;90132000;Lasers, exceto diodos laser;1;UN
9662;90138010;Dispositivos de cristais liquidos (LCD);1;UN
9663;90138090;Outros dispositivos, aparelhos e instrumentos opticos;1;UN
9664;90139000;Partes e acessorios de miras telescopicas, periscopios, etc.;1;KG
9665;90141000;Bussolas, incluindo as agulhas de marear;1;UN
9666;90142010;Altimetros para navegacao aerea ou espacial;1;UN
9667;90142020;Pilotos automaticos para navegacao aerea ou espacial;1;UN
9668;90142030;Inclinometros para navegacao aerea ou espacial;1;UN
9669;90142090;Outros instrumentos e aparelhos para navegacao aerea ou espacial;1;UN
9670;90148010;Sondas acusticas (ecobatimetros) ou de ultrassom (sonar e semelhantes);1;UN
9671;90148090;Outros aparelhos e instrumentos para navegacao;1;UN
9672;90149000;Partes e acessorios para instrumentos e aparelhos para navegacao;1;KG
9673;90151000;Telemetros;1;UN
9674;90152010;Teodolitos e taqueometros, com sistema de leitura por meio de prisma ou micrometro optico e precisao de leitura de 1 segundo;1;UN
9675;90152090;Outros teodolitos e taqueometros;1;UN
9676;90153000;Niveis;1;UN
9677;90154000;Instrumentos e aparelhos de fotogrametria;1;UN
9678;90158010;Molinetes hidrometricos;1;UN
9679;90158090;Outros instrumentos e aparelhos de geodesia, topografia, etc.;1;UN
9680;90159010;Partes e acessorios de instrumentos ou aparelhos da subposicao 9015.40 (de fotogrametria);1;KG
9681;90159090;Partes e acessorios de instrumentos e aparelhos de geodesia, etc.;1;KG
9682;90160010;Balancas sensiveis a pesos nao superiores a 0,2 mg;1;UN
9683;90160090;Balancas sensiveis a 0.2 mg < pesos <= 50 mg, com/sem pesos;1;UN
9684;90171010;Mesas e maquinas de desenhar, automaticas;1;UN
9685;90171090;Outras mesas e maquinas de desenhar;1;UN
9686;90172000;Outros instrumentos de desenho, de tracado ou de calculo;1;UN
9687;90173010;Micrometros (instrumento de medida manual de distancia);1;UN
9688;90173020;Paquimetros (instrumento de medida manual de distancia);1;UN
9689;90173090;Calibres e semelhantes (instrumento de medida manual de distancia);1;UN
9690;90178010;Metros (instrumentos de medida manual de distancias);1;UN
9691;90178090;Outros instrumentos de medida manual de distancias;1;UN
9692;90179010;Partes e acessorios de mesas e maquinas de desenhar, automaticas;1;KG
9693;90179090;Partes e acessorios de outros instrumentos de desenho, medida, etc.;1;KG
9694;90181100;Eletrocardiografos;1;UN
9695;90181210;Ecografos com analise espectral doppler;1;UN
9696;90181290;Outros aparelhos de eletrodiagnostico varredura ultra-sonica;1;UN
9697;90181300;Aparelhos de diagnostico por visualizacao de ressonancia magnetica;1;UN
9698;90181410;Scanner de tomografia por emissao de positrons (PET - Positron Emission Tomography);1;UN
9699;90181420;Camaras gama;1;UN
9700;90181490;Outros aparelhos de cintilografia;1;UN
9701;90181910;Endoscopios;1;UN
9702;90181920;Audiometros;1;UN
9703;90181980;Outros aparelhos de eletrodiagnostico;1;UN
9704;90181990;Partes de aparelhos de eletrodiagnostico;1;UN
9705;90182010;Aparelhos de raios ultravioleta ou infravermelhos, para cirurgia, que operem por laser;1;UN
9706;90182020;Outros aparelhos para tratamento bucal, que operem por laser;1;UN
9707;90182090;Outros aparelhos de raios ultravioleta ou infravermelho;1;UN
9708;90183111;Seringas, mesmo com agulhas, de plastico, de capacidade inferior ou igual a 2 cm3;1;UN
9709;90183119;Outras seringas, mesmo com agulhas, de plastico;1;UN
9710;90183190;Seringas, mesmo com agulhas, de outras materias;1;UN
9711;90183211;Agulhas tubulares de metal, gengivais;1;KG
9712;90183212;Agulhas tubulares de metal, de aco cromo-niquel, bisel trifacetado e diametro exterior superior ou igual a 1,6 mm, do tipo das utilizadas com bolsas de sangue;1;KG
9713;90183219;Outras agulhas tubulares de metal;1;KG
9714;90183220;Agulhas para suturas;1;KG
9715;90183910;Outras agulhas;1;UN
9716;90183921;Sondas, cateteres e canulas, de borracha;1;UN
9717;90183922;Cateteres de poli(cloreto de vinila), para embolectomia arterial;1;UN
9718;90183923;Cateteres de poli(cloreto de vinila), para termodiluicao;1;UN
9719;90183924;Cateteres intravenosos perifericos, de poliuretano ou de copolimero de etileno-tetrafluoretileno (ETFE);1;UN
9720;90183929;Outras sondas, cateteres e canulas;1;UN
9721;90183930;Lancetas para vacinacao e cauterios;1;UN
9722;90183991;Artigo para fistula arteriovenosa, composto de agulha, base de fixacao tipo borboleta, tubo plastico com conector e obturador;1;UN
9723;90183999;Outros instrumentos semelhantes a seringas, agulhas, cateteres, etc;1;UN
9724;90184100;Aparelhos dentarios de brocar, mesmo combinados numa base comum com outros equipamentos dentarios;1;UN
9725;90184911;Brocas para odontologia, de carboneto de tungstenio (volframio);1;UN
9726;90184912;Brocas para odontologia, de aco-vanadio;1;UN
9727;90184919;Brocas para odontologia, de outras materias;1;UN
9728;90184920;Limas para odontologia;1;UN
9729;90184940;Aparelhos que operem por projecao cinetica de particulas, para tratamento bucal;1;UN
9730;90184991;Aparelhos para desenho e construcao de pecas ceramicas para restauracoes dentarias, computadorizados;1;UN
9731;90184999;Outros instrumentos e aparelhos para odontologia;1;UN
9732;90185010;Microscopios binoculares, dos tipos utilizados em cirurgia oftalmologica;1;UN
9733;90185090;Outros instrumentos e aparelhos de oftalmologia;1;UN
9734;90189010;Outros instrumentos e aparelhos para transfusao de sangue ou infusao intravenosa;1;UN
9735;90189021;Bisturis eletricos;1;UN
9736;90189029;Outros bisturis;1;UN
9737;90189031;Litotritores por onda de choque;1;UN
9738;90189039;Litotomos e outros litotritores;1;UN
9739;90189040;Rins artificiais;1;UN
9740;90189050;Aparelhos de diatermia;1;UN
9741;90189091;Incubadoras para bebes;1;UN
9742;90189092;Aparelhos para medida da pressao arterial;1;UN
9743;90189093;Aparelhos para terapia intra-uretral por micro-ondas (TUMT), proprios para o tratamento de afeccoes prostaticas, computadorizados;1;UN
9744;90189094;Endoscopio;1;UN
9745;90189095;Grampos e clipes, seus aplicadores e extratores;1;UN
9746;90189096;Desfibriladores externos que operem unicamente em modo automatico (AED - Automatic External Defibrillator);1;UN
9747;90189099;Outros instrumentos e aparelhos para medicina, cirurgia, etc;1;UN
9748;90191000;Aparelhos de mecanoterapia, aparelhos de massagem, aparelhos de psicotecnica;1;KG
9749;90192010;Aparelhos de oxigenoterapia;1;KG
9750;90192020;Aparelhos de aerossolterapia;1;KG
9751;90192030;Respiratorios de reanimacao;1;KG
9752;90192040;Respiradores automaticos (pulmoes de aco);1;KG
9753;90192090;Aparelhos de ozonoterapia e outros de terapia respiratoria;1;KG
9754;90200010;Mascaras contra gases;1;KG
9755;90200090;Outros aparelhos respiratorios;1;KG
9756;90211010;Artigos e aparelhos ortopedicos;1;KG
9757;90211020;Artigos e aparelhos para fraturas;1;KG
9758;90211091;Partes e acessorios de artigos/aparelhos de ortopedia/articulacao;1;KG
9759;90211099;Outras partes e acessorios de aparelhos de ortopedia/fraturas;1;KG
9760;90212110;Dentes artificiais de acrilico;1;KG
9761;90212190;Dentes artificiais, exceto de acrilico;1;KG
9762;90212900;Outros artigos e aparelhos de protese dentaria;1;KG
9763;90213110;Proteses articulares femurais;1;KG
9764;90213120;Proteses articulares mioeletricas;1;KG
9765;90213190;Outras proteses articulares;1;KG
9766;90213911;Valvulas cardiacas mecanicas;1;KG
9767;90213919;Outras valvulas cardiacas;1;KG
9768;90213920;Lentes intraoculares;1;KG
9769;90213930;Proteses de arterias vasculares revestidas;1;KG
9770;90213940;Proteses mamarias nao implantaveis;1;KG
9771;90213980;Outros artigos e aparelhos de protese;1;KG
9772;90213991;Partes de proteses modulares que substituem membros superiores ou inferiores;1;KG
9773;90213999;Outras partes/acessorios de artigos e aparelhos de protese;1;KG
9774;90214000;Aparelhos para facilitar a audicao dos surdos, exceto as partes e acessorios;1;UN
9775;90215000;Marca-passos cardiacos, exceto as partes e acessorios;1;UN
9776;90219011;Cardiodesfibriladores automaticos;1;KG
9777;90219019;Outros aparelhos implantaveis organicos, para compensar defeito/incapacidade;1;KG
9778;90219081;Implantes expansiveis (stents), mesmo montados sobre cateter do tipo balao;1;KG
9779;90219082;Oclusores interauriculares constituidos por uma malha de fios de niquel e titanio preenchida com tecido de poliester, mesmo apresentados com seu respectivo cateter;1;KG
9780;90219089;Outros aparelhos para compensar deficiencias ou enfermidades;1;KG
9781;90219091;Partes e acessorios de marca-passos cardiacos;1;KG
9782;90219092;Partes e acessorios de aparelhos para facilitar a audicao dos surdos;1;KG
9783;90219099;Partes e acessorios de artigos/aparelhos para compensar deficiencia;1;KG
9784;90221200;Aparelhos de tomografia computadorizada;1;UN
9785;90221311;Aparelhos de raios X, de diagnostico, de tomadas maxilares panoramicas;1;UN
9786;90221319;Outros aparelhos de raios X, para disgnostico odontologico;1;UN
9787;90221390;Outros aparelhos de raios X, para odontologia;1;UN
9788;90221411;Aparelhos de raios X, de diagnostico para mamografia;1;UN
9789;90221412;Aparelhos de raios X, de diagnostico para angiografia;1;UN
9790;90221413;Aparelhos computadorizados de diagnostico, para densitometria ossea;1;UN
9791;90221419;Outros aparelhos de raios X, para diagnostico medico, cirurgico, etc.;1;UN
9792;90221490;Outros aparelhos de raios X, para uso medico, cirurgico, veterinario;1;UN
9793;90221910;Espectrometros ou espectrografos, de raios X;1;UN
9794;90221991;Aparelhos raios X, dos tipos utilizados para inspecao de bagagens, com tunel de altura inferior ou igual a 0,4 m, largura inferior ou igual a 0,6 m e comprimento inferior ou igual a 1,2 m;1;UN
9795;90221999;Outrps aparelhos de raios X, para radiofotografia/radioterapia;1;UN
9796;90222110;Aparelhos de radiocobalto (bombas de cobalto), para usos medicos, cirurgicos, odontologicos ou veterinarios;1;UN
9797;90222120;Aparelhos de gamaterapia para usos medicos, cirurgicos, odontologicos ou veterinarios;1;UN
9798;90222190;Outros aparelhos de radiacao alfa/beta/gama, para usos medicos, cirurgicos, odontologicos ou veterinarios;1;UN
9799;90222910;Aparelhos raios gama, para deteccao do nivel de enchimento ou tampas faltantes, em latas de bebidas, por meio de raios gama;1;UN
9800;90222990;Outros aparelhos de radiacao alfa, beta ou gama;1;UN
9801;90223000;Tubos de raios X;1;UN
9802;90229011;Geradores de tensao, para aparelhos de raios X/outras radiacoes;1;UN
9803;90229012;Telas radiologicas para aparelhos de raios X/outras radiacoes;1;UN
9804;90229019;Outros aparelhos geradores de raios X;1;UN
9805;90229080;Outros dispositivos geradores de raios X;1;UN
9806;90229090;Partes e acessorios para aparelhos de raios X/outras radiacoes, etc.;1;KG
9807;90230000;Instrumentos, aparelhos e modelos, concebidos para demonstracao (por exemplo, no ensino e nas exposicoes), nao suscetiveis de outros usos;1;KG
9808;90241010;Maquinas e aparelhos para ensaios de tracao/compressao de metais;1;UN
9809;90241020;Maquinas e aparelhos para ensaios de dureza de metais;1;UN
9810;90241090;Maquinas e aparelhos para outros ensaios de metais;1;UN
9811;90248011;Maquinas e aparelhos para ensaio de fios texteis, automaticas;1;UN
9812;90248019;Outras maquinas e aparelhos para ensaios de texteis;1;UN
9813;90248021;Maquinas para ensaios de pneumaticos;1;UN
9814;90248029;Outras maquinas e aparelhos para ensaios de papel, cartao, linoleo, etc;1;UN
9815;90248090;Outras maquinas e aparelhos para ensaios de dureza, etc, de materiais;1;UN
9816;90249000;Partes e acessorios de maquinas e aparelhos para ensaios de dureza, etc.;1;KG
9817;90251110;Termometros clinicos, de liquido, de leitura direta;1;UN
9818;90251190;Outros termometros e pirometros, de liquido, leitura direta;1;UN
9819;90251910;Pirometros opticos;1;UN
9820;90251990;Outros termometros e pirometros;1;UN
9821;90258000;Densimetros, areometros, higrometros e outros instrumentos;1;UN
9822;90259010;Partes e acessorios de termometros;1;KG
9823;90259090;Partes e acessorios de densimetros e outros instrumentos;1;KG
9824;90261011;Medidor-transmissor eletronico inducao eletromagnetica, de vazao;1;UN
9825;90261019;Outros instrumentos e aparelhos para medida/controle de vazao;1;UN
9826;90261021;Instrumentos e aparelhos para medida/controle do nivel, de metais;1;UN
9827;90261029;Outros instrumentos e aparelhos para medida/controle do nivel;1;UN
9828;90262010;Manometros;1;UN
9829;90262090;Outros instrumentos e aparelhos para medida/controle da pressao;1;UN
9830;90268000;Outros instrumentos e aparelhos para medida/controle de liquido, etc.;1;UN
9831;90269010;Partes e acessorios para instrumentos e aparelhos de medida/controle nivel;1;KG
9832;90269020;Partes e acessorios para manometros;1;KG
9833;90269090;Partes e acessorios para outros instrumentos e aparelhos de medida/controle;1;KG
9834;90271000;Analisadores de gases ou de fumaca;1;UN
9835;90272011;Cromatografos de fase gasosa;1;UN
9836;90272012;Cromatografos de fase liquida;1;UN
9837;90272019;Outros cromatografos;1;UN
9838;90272021;Sequenciadores automaticos de ADN mediante eletroforese capilar;1;UN
9839;90272029;Outros aparelhos de eletroforese;1;UN
9840;90273011;Espectrografos, de emissao atomica;1;UN
9841;90273019;Outros espectrografos;1;UN
9842;90273020;Espectrofotometros;1;UN
9843;90275010;Colorimetros;1;UN
9844;90275020;Fotometros;1;UN
9845;90275030;Refratometros;1;UN
9846;90275040;Sacarimetros;1;UN
9847;90275050;Citometro de fluxo;1;UN
9848;90275090;Outros instrumentos e aparelhos que utilizem radiacoes opticas;1;UN
9849;90278011;Calorimetros;1;UN
9850;90278012;Viscosimetros;1;UN
9851;90278013;Densitometros;1;UN
9852;90278014;Aparelhos medidores de pH;1;UN
9853;90278020;Espectrometros de massa;1;UN
9854;90278030;Polarografos;1;UN
9855;90278091;Exposimetros;1;UN
9856;90278099;Outros instrumentos e aparelhos para analise/ensaio/medida;1;UN
9857;90279010;Microtomos;1;UN
9858;90279091;Partes e acessorios para espectrometros de emissao optica;1;KG
9859;90279093;Partes e acessorios para polarografos;1;KG
9860;90279099;Partes e acessorios para outros instrumentos e aparelhos para analise;1;KG
9861;90281011;Contadores de gas natural comprimido eletronico, para postos de servico;1;UN
9862;90281019;Outros contadores de gas natural comprimido, eletronicos;1;UN
9863;90281090;Outros contadores de gases;1;UN
9864;90282010;Contadores de liquidos, peso <= 50kg;1;UN
9865;90282020;Contadores de liquidos, peso > 50kg;1;UN
9866;90283011;Contadores monofasicos, para corrente eletrica alternada, digitais;1;UN
9867;90283019;Outros contadores monofasicos, para corrente eletrica alternada;1;UN
9868;90283021;Contadores bifasicos de eletricidade, digitais;1;UN
9869;90283029;Outros contadores bifasicos de eletricidade;1;UN
9870;90283031;Contadores trifasicos de eletricidade, digitais;1;UN
9871;90283039;Outros contadores trifasicos de eletricidade;1;UN
9872;90283090;Outros contadores de eletricidade;1;UN
9873;90289010;Partes e acessorios de contadores de eletricidade;1;KG
9874;90289090;Partes e acessorios para contadores de gases/liquidos;1;KG
9875;90291010;Contadores de voltas, contadores de producao ou de horas de trabalho;1;UN
9876;90291090;Taximetros, totalizadores de caminho percorrido, etc.;1;UN
9877;90292010;Indicadores de velocidade e tacometros;1;UN
9878;90292020;Estroboscopios;1;UN
9879;90299010;Partes e acessorios de indicadores de velocidade e tacometros;1;KG
9880;90299090;Partes e acessorios de outros contadores/estroboscopios;1;KG
9881;90301010;Medidores de radioatividade;1;UN
9882;90301090;Outros instrumentos e aparelhos para medida radiacoes ionizantes;1;UN
9883;90302010;Osciloscopios catodicos, digitais;1;UN
9884;90302021;Osciloscopios catodicos analogicos, de frequencia superior ou igual a 60 MHz;1;UN
9885;90302022;Vetorscopios;1;UN
9886;90302029;Outros osciloscopios catodicos analogicos;1;UN
9887;90302030;Oscilografos catodicos;1;UN
9888;90303100;Multimetros sem dispositivo registrador;1;UN
9889;90303200;Multimetros com dispositivo registrador;1;UN
9890;90303311;Voltimetros digitais;1;UN
9891;90303319;Qualquer outro voltimetro;1;UN
9892;90303321;Amperimetros sem dispositivo registrador, do tipo dos utilizados em veiculos automoveis;1;UN
9893;90303329;Outros amperimetros sem dispositivo registrador;1;UN
9894;90303390;Outros aparelhos e instrumentos sem dispositivo registrador;1;UN
9895;90303910;Instrumento/aparelho com dispositivo registrador, de teste de continuidade em circuitos impressos;1;UN
9896;90303990;Outros aparelhos e instrumentos para medida/controle tensao, etc;1;UN
9897;90304010;Analisadores de protocolo, para telecomunicacao;1;UN
9898;90304020;Analisadores de nivel seletivo, para telecomunicacao;1;UN
9899;90304030;Analisadores digitais de transmissao, para telecomunicacao;1;UN
9900;90304090;Outros instrumentos e aparelhos para telecomunicacao;1;UN
9901;90308210;Instrumentos e aparelhos para testes de circuitos integrados;1;UN
9902;90308290;Outros instrumentos e aparelhos para medida/controle de discos, etc;1;UN
9903;90308410;Instruments e aparelhos com dispositivo registrador, de teste automatico de circuito impresso montado (ATE);1;UN
9904;90308420;Instrumentos e aparelhos, com dispositivo registrador, de medidas de parametros caracteristicos de sinais de televisao ou de video;1;UN
9905;90308490;Outros instrumentos, com dispositivo registrador;1;UN
9906;90308910;Analisadores logicos de circuitos digitais;1;UN
9907;90308920;Analisadores de espectro de frequencia;1;UN
9908;90308930;Frequencimetros;1;UN
9909;90308940;Fasimetros;1;UN
9910;90308990;Outros instrumentos e aparelhos para medida controle de eletricidade, etc;1;UN
9911;90309010;Partes e acessorios para aparelhos de medida, etc, radiacao ionizante;1;KG
9912;90309090;Partes e acessorios para osciloscopios, oscilografos, etc.;1;KG
9913;90311000;Maquinas de balancear (equilibrar) pecas mecanicas;1;UN
9914;90312010;Bancos de ensaio para motores;1;UN
9915;90312090;Outros bancos de ensaio, exceto para motores;1;UN
9916;90314100;Outros instrumentos e aparelhos opticos, para controle de plaquetas (wafers) ou de dispositivos semicondutores ou para controle de mascaras ou reticulos utilizados na fabricacao de dispositivos semicondutores;1;UN
9917;90314910;Instrumentos e aparelhos para medida de parametros dimensionais de fibras de celulose, por meio de raios laser;1;UN
9918;90314920;Instrumentos e aparelhos para medida da espessura de pneumaticos de veiculos automoveis, por meio de raios laser;1;UN
9919;90314990;Outros instrumentos e aparelhos opticos;1;UN
9920;90318011;Dinamometros;1;UN
9921;90318012;Rugosimetros;1;UN
9922;90318020;Maquinas para medicao tridimensional;1;UN
9923;90318030;Metros padroes;1;UN
9924;90318040;Aparelhos digitais, de uso em veiculos automoveis, para medida e indicacao de multiplas grandezas tais como: velocidade media, consumos instantaneo e medio e autonomia (computador de bordo);1;UN
9925;90318050;Aparelhos para analise de texteis, computadorizados;1;UN
9926;90318060;Celulas de carga;1;UN
9927;90318091;Instrumentos, aparelhos e maquinas para controle dimensional de pneumaticos, em condicoes de carga;1;UN
9928;90318099;Outros instrumentos, aparelhos e maquinas de medida/controle;1;UN
9929;90319010;Partes e acessorios para bancos de ensaio;1;KG
9930;90319090;Partes e acessorios para outros instrumentos e aparelhos de medida/controle;1;KG
9931;90321010;Termostatos automaticos, de expansao de fluidos;1;UN
9932;90321090;Outros termostatos automaticos;1;UN
9933;90322000;Manostatos automaticos (pressostatos);1;UN
9934;90328100;Instrumentos e aparelhos hidraulicos/pneumaticos, automaticos;1;UN
9935;90328911;Reguladores eletronicos, de voltagem, automaticos;1;UN
9936;90328919;Outros reguladores de voltagem, automaticos;1;UN
9937;90328921;Controladores eletronicos para sistema antibloqueio de freios, automatico;1;UN
9938;90328922;Controladores eletronicos para sistema de suspensao, automatico;1;UN
9939;90328923;Controladores eletronico para sistema de transmissao, automaticos;1;UN
9940;90328924;Controladores eletronicos para sistema de ignicao, automaticos;1;UN
9941;90328925;Controladores eletronicos para sistema de injecao, automaticos;1;UN
9942;90328929;Outros controladores eletronicos automaticos para veiculos automoveis;1;UN
9943;90328930;Equipamento digital automatico para controle de veiculos ferreos;1;UN
9944;90328981;Instrumentos e aparelhos automaticos para controle de pressao;1;UN
9945;90328982;Instrumentos e aparelhos automaticos para controle da temperatura;1;UN
9946;90328983;Instrumentos e aparelhos automaticos para controle da umidade;1;UN
9947;90328984;Instrumentos e aparelhos automaticos para controle de velocidade de motores;1;UN
9948;90328989;Outros instrumentos e aparelhos automatico para controle de grandeza, nao eletrico;1;UN
9949;90328990;Outros instrumentos e aparelhos automaticos, para regulacao/controle;1;UN
9950;90329010;Circuito impresso montado, para aparelhos automaticos de regulacao, etc;1;KG
9951;90329091;Partes e acessorios para termostatos automaticos;1;KG
9952;90329099;Partes e acessorios para outros aparelhos automaticos de regulacao, etc;1;KG
9953;90330000;Partes e acessorios nao especificados nem compreendidos noutras posicoes do presente Capitulo, para maquinas, aparelhos, instrumentos ou artigos do Capitulo 90;1;KG
9954;91011100;Relogios de pulso, com caixa de metais preciosos, funcionando eletricamente, mesmo com contador de tempo incorporado, de mostrador exclusivamente mecanico;1;UN
9955;91011900;Outros relogios de pulso, com caixa de metais preciosos, funcionando eletricamente, mesmo com contador de tempo incorporado;1;UN
9956;91012100;Outros relogios de pulso, mesmo com contador de tempo incorporado, com caixa de metal precioso, de corda automatica;1;UN
9957;91012900;Outros relogios de pulso, mesmo com contador de tempo incorporado, com caixa de metal precioso;1;UN
9958;91019100;Relogio de bolso e semelhantes, com caixa de metal precioso, etc, funcionando eletricamente;1;UN
9959;91019900;Outros relogios de bolso, semelhantes, caixa de metal precioso, etc.;1;UN
9960;91021110;Relogios de pulso, funcionando eletricamente, mesmo com contador de tempo incorporado, de mostrador exclusivamente mecanico, com caixa de metal comum;1;UN
9961;91021190;Outros relogios de pulso, funcionando eletricamente, mesmo com contador de tempo incorporado, de mostrador exclusivamente mecanico;1;UN
9962;91021210;Relogios de pulso, funcionando eletricamente, mesmo com contador de tempo incorporado, de mostrador exclusivamente optoeletronico, com caixa de metal comum;1;UN
9963;91021220;Relogios de pulso, funcionando eletricamente, mesmo com contador de tempo incorporado, de mostrador exclusivamente optoeletronico, com caixa de plastico, exceto as reforcadas com fibra de vidro;1;UN
9964;91021290;Outros relogios de pulso, funcionando eletricamente, de mostrador exclusivamente optoeletronico;1;UN
9965;91021900;Outros relogios de pulso, funcionamento eletrico;1;UN
9966;91022100;Relogio de pulso, de corda automatico;1;UN
9967;91022900;Outros relogios de pulso;1;UN
9968;91029100;Relogio de bolso, semelhantes, funcionament eletrico;1;UN
9969;91029900;Outros relogios de bolso, semelhantes;1;UN
9970;91031000;Despertadores e outros relogios, com maquinismo de pequeno volume, funcionando eletricamente;1;UN
9971;91039000;Despertadores e outros relogios, com maquinismo de pequeno volume, funcionamento nao eletrico;1;UN
9972;91040000;Relogios para paineis de instrumentos e relogios semelhantes, para automoveis, veiculos aereos, embarcacoes ou para outros veiculos;1;UN
9973;91051100;Despertadores funcionando eletricamente, exceto os com maquinismo de pequeno volume;1;UN
9974;91051900;Despertadores funcionando de outro modo, exceto os com maquinismo de pequeno volume;1;UN
9975;91052100;Relogios de parede funcionado eletricamente, exceto os com maquinismo de pequeno volume;1;UN
9976;91052900;Relogios de parede funcionado de outro modo, exceto os com maquinismo de pequeno volume;1;UN
9977;91059100;Outros artigos de relojoaria, funcionando eletricamente, exceto os com maquinismo de pequeno volume;1;UN
9978;91059900;Outros aparelhos de relojoaria, exceto os com maquinismo de pequeno volume;1;UN
9979;91061000;Relogios de ponto, relogios datadores e contadores de horas;1;UN
9980;91069000;Outros aparelhos de controle de tempo e contadores de tempo, com maquinismo de aparelhos de relojoaria ou com motor sincrono;1;UN
9981;91070010;Interruptores horarios;1;UN
9982;91070090;Outros aparelhos para acionar mecanismo em tempo determinado, etc;1;UN
9983;91081110;Maquinismos de pequeno volume para relogios, completos e montados, funcionando eletricamente, de mostrador exclusivamente mecanico ou com um dispositivo que permita incorporar um mostrador mecanico, para relogios das posicoes 91.01 ou 91.02;1;UN
9984;91081190;Maquinismo montado para outros relogios, etc;1;UN
9985;91081200;Maquinismos de pequeno volume para relogios, completos e montados, funcionando eletricamente, de mostrador exclusivamente optoeletronico, para relogios das posicoes 91.01 ou 91.02;1;UN
9986;91081900;Outros maquinismos de pequeno volume para relogios, completos e montados, funcionando eletricamente;1;UN
9987;91082000;Maquinismo montado para relogio de pequeno volume, de corda automatica;1;UN
9988;91089000;Outros maquinismos de pequeno volume para relogios, montados;1;UN
9989;91091000;Maquinismos de artigos de relojoaria, completos e montados, exceto de pequeno volume, funcionando eletricamente;1;UN
9990;91099000;Maquinismos de artigos de relojoaria, completos e montados, exceto de pequeno volume, funcionando de outro modo;1;UN
9991;91101110;Maquinismos completos, de pequeno volume, nao montados ou parcialmente montados (chablons), para relogios das posicoes 91.01 ou 91.02 (relogios de pulso);1;UN
9992;91101190;Maquinismos completos, de pequeno volume, nao montados ou parcialmente montados (chablons), para outros relogios;1;UN
9993;91101200;Maquinismos incompletos, montados, de pequeno volume;1;KG
9994;91101900;Esbocos de maquinismos para aparelhos de relojoaria de pequeno volume;1;KG
9995;91109000;Maquinismo nao montado completo para aparelhos de relojoaria, exceto de pequeno volume;1;KG
9996;91111000;Caixas de relogios, de metais preciosos ou de metais folheados ou chapeados de metais preciosos (plaque);1;UN
9997;91112010;Caixas para relogios de metais comuns, mesmo dourados ou prateados, de latao, em esboco;1;UN
9998;91112090;Caixas para relogio de pulso/bolso, de outros metais comuns;1;UN
9999;91118000;Caixas para relogio de pulso/bolso, de outras materias;1;UN
10000;91119010;Fundos para caixa de relogio de pulso/bolso, de metal comum;1;KG
10001;91119090;Outras partes para caixa de relogio de pulso/bolso;1;KG
10002;91122000;Caixas e semelhantes de apars.de relojoaria;1;UN
10003;91129000;Partes para caixas e semelhantes para aparelhos de relojoaria;1;KG
10004;91131000;Pulseiras para relogios, de metal precioso, folheado, etc.;1;KG
10005;91132000;Pulseiras para relogios, de metal comum;1;KG
10006;91139000;Pulseiras para relogios, de outras materias, e partes para pulseiras;1;KG
10007;91141000;Molas, incluindo as espirais, para artigos de relojoaria;1;KG
10008;91143000;Quadrantes para artigos de relojoaria;1;KG
10009;91144000;Platinas e pontes para artigos de relojoaria;1;KG
10010;91149010;Coroas para artigos de relojoaria;1;KG
10011;91149020;Ponteiros para artigos de relojoaria;1;KG
10012;91149030;Hastes para artigos de relojoaria;1;KG
10013;91149040;Basculas para aparelhos de relojoaria;1;KG
10014;91149050;Eixos e pinhoes para aparelhos de relojoaria;1;KG
10015;91149060;Rodas para aparelhos de relojoaria;1;KG
10016;91149070;Rotores para aparelhos de relojoaria;1;KG
10017;91149090;Outras partes e acessorios para aparelhos de relojoaria;1;KG
10018;92011000;Pianos verticais;1;UN
10019;92012000;Pianos de cauda;1;UN
10020;92019000;Outros pianos, cravos e outros instrumentos de cordas, com teclado;1;UN
10021;92021000;Instrumentos musicais de cordas, tocados com o auxilio de um arco;1;UN
10022;92029000;Outros instrumentos musicais de cordas;1;UN
10023;92051000;Instrumentos musicais de sopro denominados metais;1;UN
10024;92059000;Outros instrumentos musicais de sopro;1;UN
10025;92060000;Instrumentos musicais de percussao (por exemplo, tambores, caixas, xilofones, pratos, castanholas, maracas);1;UN
10026;92071010;Sintetizadores (instrumentos musicais de teclado);1;UN
10027;92071090;Outros instrumentos musicais de teclado;1;UN
10028;92079010;Guitarras e contrabaixos;1;UN
10029;92079090;Outros instrumentos musicais com som amplificado por meio eletrico;1;UN
10030;92081000;Caixas de musica;1;UN
10031;92089000;Orgaos mecanicos de feira e outros instrumentos musicais;1;UN
10032;92093000;Cordas para instrumentos musicais;1;KG
10033;92099100;Partes e acessorios de pianos;1;KG
10034;92099200;Partes e acessorios de instrumentos musicais da posicao 92.02 (instrumentos musicais de cordas);1;KG
10035;92099400;Partes e acessorios de instrumentos musicais da posicao 92.07 (instrumentos musicais com som amplificado por meio eletrico);1;KG
10036;92099900;Partes e acessorios para outros instrumentos musicais;1;KG
10037;93011000;Pecas de artilharia (por exemplo, canhoes, obuses e morteiros);1;UN
10038;93012000;Lanca-misseis, lanca-chamas, lanca-granadas, lanca-torpedos e lancadores semelhantes;1;UN
10039;93019000;Outras armas de guerra, exceto revolveres, pistolas e armas brancas.;1;UN
10040;93020000;Revolveres e pistolas, exceto os das posicoes 93.03 ou 93.04;1;UN
10041;93031000;Armas de fogo carregaveis exclusivamente pela boca;1;UN
10042;93032000;Outras espingardas e carabinas de caca ou de tiro ao alvo, com pelo menos um cano liso;1;UN
10043;93033000;Outras espingardas e carabinas de caca ou de tiro ao alvo;1;UN
10044;93039000;Outras armas de fogo que utilizam deflagracao da polvora, etc.;1;UN
10045;93040000;Outras armas (por exemplo, espingardas, carabinas e pistolas, de mola, de ar comprimido ou de gas, cassetetes), exceto as da posicao 93.07;1;UN
10046;93051000;Partes e acessorios de revolveres ou pistolas;1;KG
10047;93052000;Partes e acessorios de espingardas ou carabinas da posicao 93.03;1;KG
10048;93059100;Partes e acessorios de armas de guerra da posicao 93.01;1;KG
10049;93059900;Partes e acessorios de outras armas;1;KG
10050;93062100;Cartuchos para espingardas ou carabinas de cano liso;1;KG
10051;93062900;Chumbos para carabinas de ar comprimido, partes para cartuchos;1;KG
10052;93063000;Outros cartuchos e suas partes;1;KG
10053;93069000;Bombas, granadas, outras municoes e projeteis e suas partes;1;KG
10054;93070000;Sabres, espadas, baionetas, lancas e outras armas brancas, suas partes e bainhas;1;KG
10055;94011010;Assentos ejetaveis, dos tipos utilizados em veiculos aereos;1;UN
10056;94011090;Assentos dos tipos utilizados em veiculos aereos, exceto ejetaveis;1;UN
10057;94012000;Assentos dos tipos utilizados em veiculos automoveis;1;UN
10058;94013010;Assentos giratorios de altura ajustavel, de madeira;1;UN
10059;94013090;Assentos giratorios de altura ajustavel, de outras materias;1;UN
10060;94014010;Assentos (exceto de jardim ou de acampamento) transformaveis em camas, de madeira;1;UN
10061;94014090;Assentos (exceto de jardim ou de acampamento) transformaveis em camas, de outras materias;1;UN
10062;94015200;Assentos de bambu;1;UN
10063;94015300;Assentos de rotim;1;UN
10064;94015900;Assentos de vime ou materias semelhantes;1;UN
10065;94016100;Assentos estofados, com armacao de madeira;1;UN
10066;94016900;Outros assentos com armacao de madeira;1;UN
10067;94017100;Assentos estofados, com armacao de metal;1;UN
10068;94017900;Outros assentos com armacao de metal;1;UN
10069;94018000;Outros assentos;1;UN
10070;94019010;Partes para assentos, de madeira;1;KG
10071;94019090;Partes para assentos, de outras materias;1;KG
10072;94021000;Cadeiras de dentista, cadeiras para saloes de cabeleireiro e cadeiras semelhantes, e suas partes;1;KG
10073;94029010;Mesas de operacao cirurgica;1;KG
10074;94029020;Camas dotadas de mecanismos para usos clinicos;1;KG
10075;94029090;Outros mobiliarios para medicina, cirurgia, odontologia, etc.;1;KG
10076;94031000;Moveis de metal, do tipo utilizado em escritorios;1;UN
10077;94032000;Outros moveis de metal;1;UN
10078;94033000;Moveis de madeira, do tipo utilizado em escritorios;1;UN
10079;94034000;Moveis de madeira, do tipo utilizado em cozinhas;1;UN
10080;94035000;Moveis de madeira, do tipo utilizado em quartos de dormir;1;UN
10081;94036000;Outros moveis de madeira;1;UN
10082;94037000;Moveis de plasticos;1;UN
10083;94038200;Moveis de bambu;1;KG
10084;94038300;Moveis de rotim;1;KG
10085;94038900;Moveis de vime ou de materias semelhantes;1;UN
10086;94039010;Partes para moveis, de madeira;1;KG
10087;94039090;Partes para moveis, de outras materias;1;KG
10088;94041000;Suportes para camas (somies);1;KG
10089;94042100;Colchoes de borracha alveolar ou de plasticos alveolares, mesmo recobertos;1;UN
10090;94042900;Colchoes de outras materias;1;UN
10091;94043000;Sacos de dormir;1;UN
10092;94049000;Edredoes, almofadas, pufes, travesseiros e artigos semelhantes;1;KG
10093;94051010;Lampadas escialiticas (luzes sem sombra, do tipo utilizado em medicina, cirurgia, odontologia);1;KG
10094;94051091;Lustres e aparelhos iluminadores eletricos, de pedra, para teto/parede;1;KG
10095;94051092;Lustres e aparelhos iluminadores eletricos, de vidro, para teto/parede;1;KG
10096;94051093;Lustres e aparelhos iluminadores eletricos, de metal comum, para teto/parede;1;KG
10097;94051099;Lustres e aparelhos iluminadores eletricos, de outros materiais, para teto/parede;1;KG
10098;94052000;Abajures de cabeceira, de escritorio e lampadarios de interior, eletricos;1;KG
10099;94053000;Guirlandas eletricas dos tipos utilizados em arvores de Natal;1;KG
10100;94054010;Outros aparelhos eletricos de iluminacao, de metais comuns;1;KG
10101;94054090;Outros aparelhos eletricos de iluminacao, de outras materias;1;KG
10102;94055000;Aparelhos nao eletricos de iluminacao;1;KG
10103;94056000;Anuncios, cartazes ou tabuletas, placas indicadoras luminosos, e artigos semelhantes;1;KG
10104;94059100;Partes para aparelhos de iluminacao, de vidro;1;KG
10105;94059200;Partes para aparelhos de iluminacao, de plasticos;1;KG
10106;94059900;Partes para aparelhos de iluminacao, de outras materias;1;KG
10107;94061010;Estufas, de madeira;1;KG
10108;94061090;Outras contrucoes pre-fabricadas, de madeira;1;KG
10109;94069010;Estufas, exceto de madeira;1;KG
10110;94069020;Construcoes pre-fabricadas com estrutura de ferro ou aco e paredes exteriores constituidas principalmente dessas materias;1;KG
10111;94069090;Outras construcoes pre-fabricadas, exceto de madeira;1;KG
10112;95030010;Triciclos, patinetes, carros de pedais e outros brinquedos semelhantes com rodas, carrinhos para bonecos;1;KG
10113;95030021;Bonecos, mesmo vestidos, com mecanismo a corda ou eletrico, que representem somente seres humanos;1;UN
10114;95030022;Outros bonecos, mesmo vestidos, que representem somente seres humanos;1;UN
10115;95030029;Partes e acessorios de bonecos que representem somente seres humanos;1;KG
10116;95030031;Brinquedos que representem animais ou seres nao humanos, com enchimento;1;UN
10117;95030039;Outros brinquedos que representem animais ou seres nao humanos;1;UN
10118;95030040;Trens eletricos, incluindo os trilhos, sinais e outros acessorios;1;KG
10119;95030050;Modelos reduzidos, mesmo animados, em conjuntos para montagem, exceto os do item 9503.00.40 (trens eletricos);1;KG
10120;95030060;Outros conjuntos e brinquedos, para construcao;1;KG
10121;95030070;Quebra-cabecas (puzzles);1;UN
10122;95030080;Outros brinquedos, apresentados em sortidos ou em panoplias;1;UN
10123;95030091;Instrumentos e aparelhos musicais, de brinquedo;1;UN
10124;95030097;Outros brinquedos, com motor eletrico;1;UN
10125;95030098;Outros brinquedos, com motor nao eletrico;1;UN
10126;95030099;Outros brinquedos de qualquer tipo;1;UN
10127;95042000;Bilhares de qualquer tipo e seus acessorios;1;KG
10128;95043000;Outros jogos que funcionem por introducao de moedas, papeis-moeda, cartoes de banco, fichas ou por outros meios de pagamento, exceto os jogos de balizas automaticos (boliche);1;UN
10129;95044000;Cartas de jogar;1;UN
10130;95045000;Consoles e maquinas de jogos de video, exceto os classificados na subposicao 9504.30;1;UN
10131;95049010;Jogos de balizas automaticos;1;UN
10132;95049090;Outros artigos para jogos de salao;1;UN
10133;95051000;Artigos para festas de natal;1;KG
10134;95059000;Outros artigos para festas, carnaval ou outros divertimentos, incluindo os artigos de magia e artigos-surpresa;1;KG
10135;95061100;Esquis para esquiar na neve;1;PARES
10136;95061200;Fixadores para esquis;1;KG
10137;95061900;Outros equipamentos para esquiar na neve;1;KG
10138;95062100;Pranchas a vela;1;UN
10139;95062900;Esquis aquaticos e outros equipamentos para esportes aquaticos;1;UN
10140;95063100;Tacos completos para golfe;1;UN
10141;95063200;Bolas para golfe;1;UN
10142;95063900;Outros equipamentos para golfe;1;KG
10143;95064000;Artigos e equipamentos para tenis de mesa;1;KG
10144;95065100;Raquetes de tenis, mesmo nao encordoadas;1;UN
10145;95065900;Raquetes de badminton e raquetes semelhantes, mesmo nao encordoadas;1;UN
10146;95066100;Bolas de tenis;1;UN
10147;95066200;Bolas inflaveis;1;UN
10148;95066900;Outras bolas;1;UN
10149;95067000;Patins para gelo e patins de rodas, incluindo os fixados em calcados;1;PARES
10150;95069100;Artigos e equipamentos para cultura fisica, ginastica ou atletismo;1;KG
10151;95069900;Artigos e equipamentos para outros esportes e piscinas;1;UN
10152;95071000;Varas de pesca;1;UN
10153;95072000;Anzois, mesmo montados em sedelas;1;KG
10154;95073000;Molinetes de pesca;1;UN
10155;95079000;Outros artigos para pesca a linha, pucas, redes, iscas, caca, etc;1;UN
10156;95081000;Circos ambulantes e colecoes de animais ambulantes;1;KG
10157;95089010;Montanha-russa com percurso superior ou igual a 300 m;1;KG
10158;95089020;Carrosseis, mesmo dotados de dispositivo de elevacao, com diametro superior ou igual a 16 m;1;KG
10159;95089030;Vagonetes dos tipos utilizados em montanha-russa e similares, com capacidade superior ou igual a 6 pessoas;1;KG
10160;95089090;Outros carrosseis, balancos e outras diversoes;1;KG
10161;96011000;Marfim trabalhado e obras de marfim;1;KG
10162;96019000;Outras materias animais para entalhar, trabalhados e obras;1;KG
10163;96020010;Capsulas de gelatinas digeriveis;1;KG
10164;96020020;Colmeias artificiais;1;KG
10165;96020090;Outras materias vegetais/minerais de entalhar, trabalhos e obras, etc;1;KG
10166;96031000;Vassouras e escovas constituidas por pequenos ramos ou outras materias vegetais reunidas em feixes, com ou sem cabo;1;UN
10167;96032100;Escovas de dentes, incluindo as escovas para dentaduras;1;UN
10168;96032900;Escovas e pinceis de barba, escovas para cabelos, cilios, etc;1;UN
10169;96033000;Pinceis e escovas, para artistas, pinceis de escrever e pinceis semelhantes para aplicacao de produtos cosmeticos;1;UN
10170;96034010;Rolos para pintura;1;UN
10171;96034090;Escovas e pinceis para pintar, caiar, envernizar, etc, bonecas;1;UN
10172;96035000;Outras escovas que constituam partes de maquinas, aparelhos ou veiculos;1;UN
10173;96039000;Outras vassouras, escovas, pinceis, espanadores, rodos, etc.;1;UN
10174;96040000;Peneiras e crivos, manuais;1;UN
10175;96050000;Conjuntos de viagem para toucador de pessoas, para costura ou para limpeza de calcados ou de roupas;1;UN
10176;96061000;Botoes de pressao e suas partes;1;KG
10177;96062100;Botoes de plastico, nao recobertos de materias texteis;1;KG
10178;96062200;Botoes de metais comuns,  nao recobertos de materias texteis;1;KG
10179;96062900;Outros botoes;1;KG
10180;96063000;Formas e outras partes de botoes e esbocos de botoes;1;KG
10181;96071100;Fechos ecler (fechos de correr), com grampos de metal comum;1;KG
10182;96071900;Outros fechos ecler (fechos de correr);1;KG
10183;96072000;Partes de fechos ecler (fechos de correr);1;KG
10184;96081000;Canetas esferograficas;1;UN
10185;96082000;Canetas e marcadores, com ponta de feltro ou com outras pontas porosas;1;UN
10186;96083000;Canetas-tinteiro e outras canetas;1;UN
10187;96084000;Lapiseiras;1;UN
10188;96085000;Sortidos de artigos de, pelo menos, duas das subposicoes precedentes (canetas e lapiseiras);1;UN
10189;96086000;Cargas com ponta, para canetas esferograficas;1;UN
10190;96089100;Penas (aparos) e suas pontas, para canetas-tinteiro;1;UN
10191;96089981;Pontas porosas, para canetas e marcadores;1;KG
10192;96089989;Outras partes para canetas, lapiseiras, etc.;1;KG
10193;96089990;Estiletes para duplicadores, porta-lapis e artigos semelhantes;1;KG
10194;96091000;Lapis;1;KG
10195;96092000;Minas para lapis/lapiseiras;1;KG
10196;96099000;Pasteis, carvoes, gizes para escrever/desenhar e de alfaiate;1;KG
10197;96100000;Lousas e quadros para escrever ou desenhar, mesmo emoldurados;1;KG
10198;96110000;Carimbos, incluindo os datadores e numeradores, sinetes e artigos semelhantes (incluindo os aparelhos para impressao de etiquetas), manuais, dispositivos manuais de composicao tipografica e jogos de impressao manuais que contenham tais dispositivos;1;KG
10199;96121011;Fitas impressoras, de plastico, com tinta magnetizavel a base de oxido de ferro, para impressao de caracteres;1;UN
10200;96121012;Fitas impressoras, de plastico, corretivas (tipo cover up), para maquinas de escrever;1;UN
10201;96121013;Outras fitas impressoras, de plastico, apresentadas em cartucho, para maquinas de escrever;1;UN
10202;96121019;Outras fitas impressoras de plastico;1;UN
10203;96121090;Outras fitas impressoras de outras materias;1;UN
10204;96122000;Almofadas de carimbo;1;UN
10205;96131000;Isqueiros de bolso, a gas, nao recarregaveis;1;UN
10206;96132000;Isqueiros de bolso, a gas, recarregaveis;1;UN
10207;96138000;Outros isqueiros e acendedores;1;UN
10208;96139000;Partes de isqueiros e outros acendedores;1;KG
10209;96140000;Cachimbos (incluindo os seus fornilhos), piteiras (boquilhas) para charutos ou cigarros, e suas partes;1;KG
10210;96151100;Pentes, travessas para cabelo e artigos semelhantes, de borracha endurecida ou de plasticos;1;KG
10211;96151900;Outros pentes e travessas para cabelo, de outras materias;1;KG
10212;96159000;Grampos para cabelo, pincas e outros artigos para penteados;1;KG
10213;96161000;Vaporizadores de toucador, suas armacoes e cabecas de armacoes;1;KG
10214;96162000;Borlas ou esponjas para pos ou para aplicacao de outros cosmeticos ou de produtos de toucador;1;KG
10215;96170010;Garrafas termicas e outros recipientes isotermicos, com isolamento produzido pelo vacuo;1;KG
10216;96170020;Partes de garrafas termicas e outros recipientes isotermicos;1;KG
10217;96180000;Manequins e artigos semelhantes, automatos e cenas animadas, para vitrines e mostruarios;1;KG
10218;96190000;Absorventes e tampoes higienicos, cueiros e fraldas para bebes e artigos higienicos semelhantes, de qualquer materia;1;KG
10219;96200000;Monopes, bipes, tripes e artigos semelhantes;1;KG
10220;97011000;Quadros, pinturas e desenhos, feitos inteiramente a mao;1;UN
10221;97019000;Colagens e quadros decorativos semelhantes;1;KG
10222;97020000;Gravuras, estampas e litografias, originais;1;UN
10223;97030000;Producoes originais de arte estatuaria ou de escultura, de quaisquer materias;1;UN
10224;97040000;Selos postais, selos fiscais, marcas postais, envelopes de primeiro dia (first-day covers), inteiros postais e semelhantes, obliterados, ou nao obliterados, exceto os artigos da posicao 49.07;1;KG
10225;97050000;Colecoes e especimes para colecoes, de zoologia, botanica, mineralogia, anatomia, ou apresentando interesse historico, arqueologico, paleontologico, etnografico ou numismatico;1;KG
10226;97060000;Antiguidades com mais de 100 anos;1;KG