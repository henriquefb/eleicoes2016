# eleicoes2016
Guia do IMP para as Eleições 2016

# Lista de arquivos

- perfil.do (STATA): Baixa dados do TSE entre 1996 e 2016 sobre caracteristicas do eleitorado, detalha o perfil eleitoral por educação e tamanho do município e cria arquivos do Excel para isso
- partidos.do (STATA): Usa dados do arquivo resultados19962012.txt, organizado com dados brutos do TSE sobre resultados eleitorais, para detalhar a distribuicao de prefeituras entre blocos de alianças eleitorais distintas (tucanos, petistas e outros) e o papel do PMDB nos outros.
- completo.do (STATA): Importa os dados das candidaturas municipais de 2016 do site do TSE, agrega a eles dados de população (IBGE), IDHM (PNUD), renda (PNUD) e georeferenciamento (IBGE) de todos os municípios, cria arquivo unificados para candidaturas proporcionais e majoritárias. Sumariza o número de candidaturas por município. Utiliza o string "coligacao" para construir dummies para cada um dos partidos com representação no congresso nacional. Constroi uma matriz que denota a coincidência das dummies - ou seja, a existência de coligação naquele município para os partidos coincidentes. Exporta esses dados para um arquivo chamado "prefeito.csv".
- mapa.R (R): Utiliza os dados indexados em "prefeito.csv" para ver quando há coligações entre o PMDB e o PT; e o PMDB e o PSDB. Cria vetores para as coincidências e utiliza as coordenadas geográficas dos municípios onde há coincidência em um mapa.

