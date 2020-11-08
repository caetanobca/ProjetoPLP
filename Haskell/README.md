## Instruções para instalação:

* Download do [Haskell](https://www.haskell.org/platform/)
* Download do [Stack](https://docs.haskellstack.org/en/stable/README/)

**Para importar as bibliotecas Data.List.Split e System.IO.Strict com o stack, rode o seguinte no PowerShell dentro da pasta do projeto:**

	stack setup
	
	stack init
	
	stack build split

	stack build strict
	
	stack build brick

**Finalmente, para iniciar o BloodLife:**

	stack main.hs
