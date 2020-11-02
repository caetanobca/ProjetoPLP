module Recebedor where 
	import Data.List
	import Data.Maybe()
	import Data.Map as Map
	import Data.Char
	import System.IO

	data Recebedor = Recebedor { nome :: String, endereco :: String, idade :: Int, telefone :: String, quantidademl :: Int} deriving (Show, Eq)

	adicionaRecebedor :: String -> String -> Int -> String -> Int -> Recebedor
	adicionaRecebedor nome endereco idade telefone quantidademl = (Recebedor {nome = nome, endereco = endereco, idade = idade, telefone = telefone, quantidademl = quantidademl})

	encontraRecebedorString :: String -> [Recebedor] -> String
	encontraRecebedorString procurado [] = "Recebedores: \n"
	encontraRecebedorString procurado (h:t)
		|isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = show h ++ encontraRecebedorString procurado t
		|otherwise = encontraRecebedorString procurado t

	encontraRecebedor :: String -> [Recebedor] -> Maybe Recebedor
	encontraRecebedor procurado [] = Nothing
	encontraRecebedor procurado (h:t)
		|isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = Just h
		|otherwise = encontraRecebedor procurado t
{-
	imprimeRecebedor :: String -> [Recebedor] -> String
	imprimeRecebedor procurado = "Nome " ++ nome procurado ++ " " ++ "Endereco" ++ endereco procurado ++ " " ++ "Idade: " ++ show (idade procurado) ++ " "
		++ "Telefone: " ++ telefone procurado ++ " " ++ "Quantidade de Sangue Necessária em ml: " ++ show (quantidademl procurado ) ++ "\n"
-}
	todosOsRecebedores :: [Recebedor] -> String
	todosOsRecebedores [] = " "
	todosOsRecebedores (h:t) = "Nome " ++ nome h ++ " " ++ "Endereco" ++ endereco h ++ " " ++ "Idade: " ++ show (idade h) ++ " "
		++ "Telefone: " ++ telefone h ++ " " ++ "Quantidade de Sangue Necessária em ml: " ++ show (quantidademl h) ++ "\n" ++ todosOsRecebedores t

	recebedorCadastrado :: String -> [Recebedor] -> Bool
	recebedorCadastrado procurado [] = False
	recebedorCadastrado procurado (h:t)
		|isInfixOf (toUpperCase procurado) (toUpperCase (nome h)) == True = True
		|otherwise = recebedorCadastrado procurado t


	toUpperCase :: String -> String
	toUpperCase entrada = [toUpper x | x <- entrada]


	cadastrarRecebedor :: IO()
	cadastrarRecebedor = do
		nome <- prompt "Digite o nome do(a) Recebedor(a) "
		endereco <- prompt "Digite o endereço do(a) Recebedor(a) "
		input <- prompt "Digite a idade do(a) Recebedor(a) "
		let idade = read input
		telefone <- prompt "Digite o telefone do(a) Recebedor(a) "
		input <- prompt "Digite a quantidade de sangue em ml que o(a) Recebedor(a) precisa "
		let quantidade = read input
		let recebedor = adicionaRecebedor nome endereco idade telefone quantidade
		putStr "Recebedor Cadastrado"


	prompt :: String -> IO String
	prompt text = do
		putStr text
		hFlush stdout
		getLine

	-- Ainda falta implementar Ficha de Dados Medicos, estou pensando em fazer um outro objeto Ficha para usar aqui será que é uma boa
	

