# Descrição

Este repositório contém dados, códigos e gráficos da seguinte publicação:

Meira, R.; Góes, C. (2016).
“Uma radiografia das eleições municipais brasileiras (1996-2016): fatos e dados”.
Nota de Política Pública n. 02/2016.
São Paulo: Instituto Mercado Popular.

O Instituto Mercado Popular tem um compromisso com a reprodutibilidade das análises e modelos publicados sob sua marca. Os dados utilizados para a construção dos gráficos e modelos estatísticos deste artigo, se existentes e não proprietários, serão disponibilizados em www.github.com/omercadopopular. Sempre que possível, os códigos de computador utilizados também serão disponibilizados. Caso você não consiga encontrar os dados em nosso repositório e os queira, contacte diretamente os autores.

# Sobre o Instituto Mercado Popular

O Instituto Mercado Popular é um laboratório de políticas públicas. Nossa missão é racionalizar e democratizar o debate político e econômico no país, provendo alternativas políticas baseadas no estado da arte da evidência científica, disseminando essas ideias entre a população e facilitando transformações que contribuam para uma sociedade livre, aberta e justa.

# Lista de arquivos

- [perfil.do](https://github.com/omercadopopular/eleicoes2016/blob/master/perfil.do) (STATA): Baixa dados do TSE entre 1996 e 2016 sobre caracteristicas do eleitorado, detalha o perfil eleitoral por educação e tamanho do município e cria arquivos do Excel para isso
- partidos.do (STATA): Usa dados do arquivo resultados19962012.txt, organizado com dados brutos do TSE sobre resultados eleitorais, para detalhar a distribuicao de prefeituras entre blocos de alianças eleitorais distintas (tucanos, petistas e outros) e o papel do PMDB nos outros. Calcula o número efetivo de partidos para cada eleição entre 1996 e 2012.
- completo.do (STATA): Importa os dados das candidaturas municipais de 2016 do site do TSE, agrega a eles dados de população (IBGE), IDHM (PNUD), renda (PNUD) e georeferenciamento (IBGE) de todos os municípios, cria arquivo unificados para candidaturas proporcionais e majoritárias. Sumariza o número de candidaturas por município. Utiliza o string "coligacao" para construir dummies para cada um dos partidos com representação no congresso nacional. Constroi uma matriz que denota a coincidência das dummies - ou seja, a existência de coligação naquele município para os partidos coincidentes. Exporta esses dados para um arquivo chamado "prefeito.csv".
- mapa.R (R): Utiliza os dados indexados em "prefeito.csv" para ver quando há coligações entre o PMDB e o PT; e o PMDB e o PSDB. Cria vetores para as coincidências e utiliza as coordenadas geográficas dos municípios onde há coincidência em um mapa.

