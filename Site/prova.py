import os
sair = 0
total_apagar = 0
valor_compra = 0
opcao = " "
preco_1 = 1.89
preco_2 = 3.3
while sair != 2:
    print("--------------- SISLOJA 2022 ---------------")
    sair = int(input("Digite '1' para fazer login ou '2' para finalizar o programa: "))
    os.system("cls")
    if sair == 1:
        break
while sair == 1:
    print("Digite as suas credenciais: ")
    login = input("login: ")
    senha = input("senha: ")
    os.system("cls")
    if login == "x" and senha == "x":
        print(f"Ola {login}, seja bem vindo ao SISLOJA")
        continuar = input("Tecle enter para continuar...")
        os.system("cls")
        while opcao != 3:
            print("Digite, dentre as opções abaixo, o serviço que deseja operar:\n1 - abrir venda \n2 - ver/editar produtos\n3 -fechar sistema")
            opcao = int(input("Digite a opção escolhida: "))
            total_apagar = 0
            os.system("cls")
            while opcao == 1:
                escolha_d_compra = int(input("Digite 1 para produto avulso e 2 para produto cadastrado ou 0 para finalizar a compra\nDigite a opção escolhida: "))
                if escolha_d_compra == 1:
                    valor_produto = float(input("Qual o valor do produto? "))
                    quantidade = int(input("Digite a quantidade de produto: "))
                    valor_compra = valor_produto * quantidade
                    total_apagar += valor_compra
                    os.system("cls")
                elif escolha_d_compra == 2:
                    nome_produto = input("Digite o nome do produto: ")
                    quantidade_2 = int(input("Digite a quantidade: "))
                    if nome_produto == "arroz":
                        valor_compra = quantidade_2 * preco_1
                        total_apagar += valor_compra
                        os.system("cls")
                    elif nome_produto == "macarrao":
                        valor_compra = quantidade_2 * preco_2
                        total_apagar += valor_compra
                        os.system("cls")
                elif escolha_d_compra == 0:
                    input(f"O total a pagar foi {total_apagar}, aperte enter para voltar ao menu inicial...")
                    os.system("cls")
                    break
            while opcao == 2:
                print(f"=======================\nNome produto 1: arroz | valor:{preco_1} \nNome produto 2: macarrao | valor:{preco_2}\n=========================")
                alterar = int(input("1-alterar preço do produto 1\n2-alterar preço do produto 2\n3-voltar ao menu inicial\nDigite a opção escolhida: "))
                os.system("cls")
                if alterar == 1:
                    preco_1 = float(input("Digite o novo valor do produto: "))
                    os.system("cls")
                elif alterar == 2:
                    preco_2 = float(input("Digite o novo valor do produto: "))
                    os.system("cls")
                elif alterar == 3:
                    os.system("cls")
                    break
        else:
            break

    else:
        print("Usuário ou senha incorretos. Tente Novamente")
print("Sistema encerrado, até logo")