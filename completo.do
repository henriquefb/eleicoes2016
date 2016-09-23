///////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ESCRITO POR /////////////////////////////////
///////////////////////////////// CARLOS GÓES /////////////////////////////////
////////////////////////////////////// E //////////////////////////////////////
//////////////////////////////// RADUAN MEIRA /////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////// INSTITUTO MERCADO POPULAR ///////////////////////////
/////////////////////////// www.mercadopopular.org ////////////////////////////
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
////////////////////////////////// LEIA-ME ////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*

Descrição do projeto

 
 */
///////////////////////////////////////////////////////////////////////////////
////////////////////////////////// INTERFACE //////////////////////////////////
//////////// ALTERE OS VALORES DESTA SEÇÃO PARA CUSTOMIZAR A ANÁLISE //////////
///////////////////////////////////////////////////////////////////////////////

// Rodar rotina que baixa e prepara dados (só é necessário uma vez)? Sim = 1, Não = 0	
	local preparacao_dados = 0

// Rodar rotina faz a análise? Sim = 1, Não = 0	
	local analise = 1

// Defina seu diretório de trabalho
	local diretorio = "U:\Research\partidos\basededados"

// Lista de partidos incluídos na análise
	local partidos = "PMDB	PT	PSDB	PP	PR	PSD	PSB	DEM	PRB	PDT	PTB	SD	PTN	PCdoB	PSC	PPS	PHS	PV	PSOL	PROS	REDE	PTdoB	PEN	PSL	PMB PRP" 

// Número de partidos incluídos na análise
	scalar npartidos = 26

 
///////////////////////////////////////////////////////////////////////////////
///////////////////////// CÓDIGO (USUÁRIOS AVANÇADOS) /////////////////////////
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
/////////////////////////// 1. ORGANIZAÇÃO DO ESPAÇO //////////////////////////
///////////////////////////////////////////////////////////////////////////////
 
capture log close 										// closes any open logs
clear 													// clears the memory
clear matrix 											// clears matrix memory
clear mata 												// clears mata memory
cd "`diretorio'" 
set more off  																					
log using dataconsolidation.log, replace  	

///////////////////////////////////////////////////////////////////////////////
/////////////////////////// 2. PREPARAÇÃO DOS DADOS ///////////////////////////
///////////////////////////////////////////////////////////////////////////////

if (`preparacao_dados' == 1) {

	copy "http://agencia.tse.jus.br/estatistica/sead/odsele/consulta_legendas/consulta_legendas_2016.zip" consulta_legendas_2016.zip, replace
	unzipfile consulta_legendas_2016.zip, replace

	local estados = "AC AL AM AP BA CE ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP"

	// loop

	foreach x in `estados' {
		import delimited consulta_legendas_2016_`x'.txt, delimiter(";") clear
		tempfile merge_file`x'
		drop v1 v2 v4 v5 v14 v15 v18
		rename v3 ano
		rename v6 estado
		rename v7 municipio_codigo
		rename v8 municipio
		rename v9 cargo_codigo
		rename v10 cargo
		rename v11 tipo
		rename v12 partido_codigo
		rename v13 partido
		rename v16 coligacao_nome
		rename v17 coligacao_partidos
		save `merge_file`x''
	}

	// to
		import delimited consulta_legendas_2016_TO.txt, delimiter(";") clear
		drop v1 v2 v4 v5 v14 v15 v18
		rename v3 ano
		rename v6 estado
		rename v7 municipio_codigo
		rename v8 municipio
		rename v9 cargo_codigo
		rename v10 cargo
		rename v11 tipo
		rename v12 partido_codigo
		rename v13 partido
		rename v16 coligacao_nome
		rename v17 coligacao_partidos


	foreach x in `estados' { 
		append using `merge_file`x''
	}



	save base, replace

	import delimited latlong.csv, delimiter(",") clear

	merge 1:m municipio_codigo using base

	drop _merge

	save base, replace

	preserve
		keep if cargo == "PREFEITO"
		save prefeito, replace
	restore

	preserve
		keep if cargo == "VEREADOR"
		save vereador, replace
	restore
}

///////////////////////////////////////////////////////////////////////////////
////////////////////////////////// 3. ANALISE ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

if (`analise' == 1) {

	capture log close 										// closes any open logs
	clear 													// clears the memory
	clear matrix 											// clears matrix memory
	clear mata 												// clears mata memory
	set more off  																					
	log using analise.log, replace  	
		
	use prefeito, clear

	// ajustes pré-análise

		// criar dummy para coligação

		gen coligacao = 0
		replace coligacao = 1 if tipo == "COLIGACAO"

		// preservar partidos não-coligados

		preserve
			keep if tipo == "PARTIDO ISOLADO"
			tempfile partidoisolado
			save partidoisolado, replace
		restore

		// manter somente uma linha por coligação

		keep if tipo == "COLIGACAO"
		replace partido_codigo = .
		replace partido = ""

		egen coligacao_codigo = group(municipio_codigo coligacao_nome)

		collapse (mean) ano municipio_codigo cargo_codigo partido_codigo coligacao latitude longitude pobres idhm rendapercapita populacao (first) estado municipio cargo tipo partido coligacao_nome coligacao_partidos, by(coligacao_codigo)

		drop coligacao_codigo

		// restaurar partidos não-coligados

		append using partidoisolado
		
		// assinalar cabeças de chapa
		
		split coligacao_partidos, parse(" / ") generate(temp_part)
		replace partido = temp_part1 if coligacao == 1
		drop temp_part*
		
		// ajustar partidos com espaços

		replace partido = "PCdoB" if partido == "PC do B"
		replace partido = "PTdoB" if partido == "PT do B"
		replace coligacao_partidos = subinstr(coligacao_partidos,"PT do B","PTdoB",.)
		replace coligacao_partidos = subinstr(coligacao_partidos,"PC do B","PCdoB",.)

		
		// assinalar dummies para partidos

		foreach y in `partidos' {
				gen `y' = 0
				replace `y' = regexm(coligacao_partidos, " `y' ")
				replace `y' = 1 if partido == "`y'" 
			}

	// análise

	// exportar número de candidaturas por municípios

	gen n = 0
	bysort municipio_codigo: replace n = _n
	bysort municipio_codigo: egen candidaturas_mun = max(n)
	drop n


	preserve
		collapse (mean) pobres idhm rendapercapita candidaturas_mun populacao (first) municipio estado, by(municipio_codigo)

		histogram candidaturas_mun, bin(16)  ///
		  title("Eleições de 2016: Distribuição de Candidaturas a Prefeito", position(11) margin(vsmall) size(medium)) ///
		  subtitle("(Distribuição percentual de municípios por candidaturas)",  position(11) margin(vsmall) size(small)) ///
		  caption("Fonte: Cálculos do IMP, com dados do TSE", size(vsmall)) ///
		  ytitle("%", box fcolor(white)) xtitle("Número de candidaturas",box fcolor(white)) ///
		  saving(histograma1, replace) name(histograma1, replace)  
		  
  		histogram populacao, bin(5)  ///
		  title("Eleições de 2016: Distribuição da População", position(11) margin(vsmall) size(medium)) ///
		  subtitle("(Distribuição percentual de municípios por candidaturas)",  position(11) margin(vsmall) size(small)) ///
		  caption("Fonte: Cálculos do IMP, com dados do TSE", size(vsmall)) ///
		  ytitle("%", box fcolor(white)) xtitle("População",box fcolor(white)) ///
		  saving(histograma2, replace) name(histograma2, replace)  
		   
		twoway scatter candidaturas_mun populacao || qfit candidaturas_mun populacao, ///
		  title("Eleições de 2016: População e Número de Candidaturas a Prefeito", position(11) margin(vsmall) size(medium)) ///
		  subtitle("(Em número absoluto de população e candidaturas)",  position(11) margin(vsmall) size(small)) ///
		  caption("Fonte: Cálculos do IMP, com dados do TSE e do IBGE", size(vsmall)) ///
		  ytitle("Número de candidaturas", box fcolor(white)) xtitle("População (escala logarítimica)",box fcolor(white)) ///
		  xsca(log) xlab(1000 10000 100000 1000000 1000000, grid) legend(off) ///
		  saving(scatter1, replace) name(scatter1, replace)  

		twoway scatter candidaturas_mun rendapercapita || qfit candidaturas_mun rendapercapita, ///
		  title("Eleições de 2016: População e Número de Candidaturas a Prefeito", position(11) margin(vsmall) size(medium)) ///
		  subtitle("(Em renda familiar per capita e candidaturas)",  position(11) margin(vsmall) size(small)) ///
		  caption("Fonte: Cálculos do IMP, com dados do TSE e do PNUD", size(vsmall)) ///
		  ytitle("Número de candidaturas", box fcolor(white)) xtitle("Renda familiar per capita",box fcolor(white)) ///
		  legend(off) ///
		  saving(scatter2, replace) name(scatter2, replace)  

		twoway scatter candidaturas_mun idhm || qfit candidaturas_mun idhm, ///
		  title("Eleições de 2016: População e Número de Candidaturas a Prefeito", position(11) margin(vsmall) size(medium)) ///
		  subtitle("(Índice e número de candidaturas)",  position(11) margin(vsmall) size(small)) ///
		  caption("Fonte: Cálculos do IMP, com dados do TSE e do PNUD", size(vsmall)) ///
		  ytitle("Número de candidaturas", box fcolor(white)) xtitle("IDHM",box fcolor(white)) ///
		  legend(off) ///
		  saving(scatter3, replace) name(scatter3, replace)  

		
		export excel using "canidatura_mun", replace firstrow(var)
	restore


	// matrizes

	forval x = 1/4 {
		matrix resultados`x' = I(npartidos)
		matrix colnames resultados`x' = `partidos'
		matrix rownames resultados`x' = `partidos'
	}

	scalar counter1 = 0

	foreach y in `partidos' {
		scalar counter1 = counter1 +1
		scalar counter2 = 0
			
		foreach z in `partidos' {
			scalar counter2 = counter2 + 1
			sum `y' if `z' == 1
			matrix resultados1[counter1,counter2] = r(mean)
			matrix resultados2[counter1,counter2] = r(N) * r(mean)
			sum `y' if partido == "`z'"
			matrix resultados3[counter1,counter2] = r(mean)
			matrix resultados4[counter1,counter2] = r(N) * r(mean)
		}
	}



	matrix list resultados1, nohalf
	matrix list resultados2, nohalf
	matrix list resultados3, nohalf
	matrix list resultados4, nohalf

	order `partidos', first

	export delimited using "prefeito", replace

}
