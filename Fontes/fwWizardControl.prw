#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"

// teste de github

// teste de github - 10/06/2017

// teste de github - 13/06/2017

// teste de github - 23/06/2017

User Function ExWzCtrl()
    Local oPanel
    Local oNewPag
    Local cCodCli := cFornec := Space(8)
    Local cNome	  := cProdDe := cProdAte:= Space(30)
    Local cGrupo  := Space(4)
    
    Local oStepWiz := nil
    Local oDlg := nil
    Local oPanelBkg

    //Para que a tela da classe FWWizardControl fique no layout com bordas arredondadas
    //iremos fazer com que a janela do Dialog oculte as bordas e a barra de titulo
    //para isso usaremos os estilos WS_VISIBLE e WS_POPUP
    DEFINE DIALOG oDlg TITLE 'Exemplo tela Wizard usando a classe FWWizardControl' PIXEL STYLE nOR(  WS_VISIBLE ,  WS_POPUP )
    oDlg:nWidth := 800
    oDlg:nHeight := 620

    oPanelBkg:= tPanel():New(0,0,"",oDlg,,,,,,300,300)
    oPanelBkg:Align := CONTROL_ALIGN_ALLCLIENT

    //Instancia a classe FWWizard
    oStepWiz:= FWWizardControl():New(oPanelBkg)
    oStepWiz:ActiveUISteps()
    
    //----------------------
    // Pagina 1
    //----------------------
    oNewPag := oStepWiz:AddStep("1")
    //Altera a descrição do step
    oNewPag:SetStepDescription("Primeiro passo")
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|cria_pg1(Panel, @cCodCli, @cNome, @cFornec)})
    //Define o bloco ao clicar no botão Próximo
    oNewPag:SetNextAction({||valida_pg1(@cCodCli, @cNome, @cFornec)})
    //Define o bloco ao clicar no botão Cancelar
    oNewPag:SetCancelAction({||Alert("Cancelou na pagina 1"), .T., oDlg:End()})
    
    //----------------------
    // Pagina 2
    //----------------------
    /*
    
    Adiciona um novo Step ao wizard

    Parametros da propriedade AddStep
    cID - ID para o step
    bConstruct - Bloco de construção da tela

    */
    oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel, @cProdDe, @cProdAte, @cGrupo)})
    oNewPag:SetStepDescription("Segundo passo")
    oNewPag:SetNextAction({||valida_pg2(@cProdDe, @cProdAte, @cGrupo)})

    //Define o bloco ao clicar no botão Voltar
    oNewPag:SetCancelAction({||Alert("Cancelou na pagina 2"), .T., oDlg:End()})
    //Ser na propriedade acima (SetCancelAction) o segundo parametro estiver com .F., não será possível voltar
    //para a página anterior
    
    oNewPag:SetPrevAction({|| .T.})
    oNewPag:SetPrevTitle("Voltar")
    
    //----------------------
    // Pagina 3
    //----------------------
    oNewPag := oStepWiz:AddStep("3", {|Panel|cria_pn3(Panel)})
    oNewPag:SetStepDescription("Terceiro passo")
    oNewPag:SetNextAction({|| Aviso("Termino","Wizard Finalizado",{"Fechar"},1), .T., oDlg:End()})
    oNewPag:SetCancelAction({||Alert("Cancelou na pagina 3"), .T., oDlg:End()})
    oNewPag:SetCancelWhen({||.F.})
    oStepWiz:Activate()
    
    ACTIVATE DIALOG oDlg CENTER
    oStepWiz:Destroy()
Return

//--------------------------
// Construção da página 1
//--------------------------
Static Function cria_pg1(oPanel, cCodCli, cNome, cFornec)
    Local oTGet0
    Local oTGet1
    Local oTGet2
    
    oSay1:= TSay():New(10,10,{||'Cliente'},oPanel,,,,,,.T.,,,200,20)
    cNome := Space(30)
    oTGet1 := tGet():New(20,010,{|u| if(PCount()&gt;0,cCodCli:=u,cCodCli)}, oPanel ,50,9,PesqPict("SA1","A1_COD"),{ || cNome:=Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME")  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"SA1","cCodCli")
    oTGet0 := tGet():New(20,062,{|u| if(PCount()&gt;0,cNome:=u,cNome)},oPanel ,220,9,PesqPict("SA1","A1_NOME")	,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"","cNome",,,,.T.,.T.)
    
    oSay2:= TSay():New(40,10,{||'Fornecedor'},oPanel,,,,,,.T.,,,200,20)
    cFornec := Space(30)
    oTGet2 := tGet():New(50,10,{|u| if(PCount()&gt;0,cFornec:=u,cFornec)}, oPanel ,50,9,PesqPict("SA2","A2_COD"),{ ||   },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"SA2","cFornec")
Return


//----------------------------------------
// Validação do botão Próximo da página 1
//----------------------------------------
Static Function valida_pg1(cCodigo, cNome, cFornec)
    Aviso("Atenção","Você digitou:" + CRLF + ;
            "Cliente: " + cCodigo + "-" + cNome + CRLF + ;
            "Fornecedor: " + cFornec,{"Continuar"},1)
Return .T.

//--------------------------
// Construção da página 2
//--------------------------
Static Function cria_pg2(oPanel, cProdDe, cProdAte, cGrupo)
    Local aItems := {'0001','0002','0003'}
    Local oCombo1
    Local oTGet1
    Local oTGet2
    Local oTGet3
    Local dData := CTOD("//")
    
    oSay1	:= TSay():New(10,10,{||'Produto de'},oPanel,,,,,,.T.,,,200,20)	
    oTGet1 	:= TGet():New(20,10,{|u| if( PCount() &gt; 0, cProdDe := u, cProdDe ) } ,oPanel,100,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1","cProdDe")
    
    oSay2	:= TSay():New(40,10,{||'Produto ate'},oPanel,,,,,,.T.,,,200,20)
    oTGet2 	:= TGet():New(50,10,{|u| if( PCount() &gt; 0, cProdAte := u, cProdAte ) },oPanel,100,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1","cProdAte")

    oSay2	:= TSay():New(70,10,{||'Grupo'},oPanel,,,,,,.T.,,,200,20)
    cCombo1	:= aItems[1]
    oCombo1 := TComboBox():New(80,10,{|u|if(PCount()&gt;0,cGrupo:=u,cGrupo)},aItems,100,20,oPanel,,{|| },,,,.T.,,,,,,,,,'cGrupo')

    oSay3  	:= TSay():New(100,10,{|| 'Data'},oPanel,,,,,,.T.,,,15,20)
    oTGet3 	:= tGet():New(110,10,{|u| if(PCount()&gt;0,dData:=u,dData)}, oPanel ,50,9,"@D",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,"dData")

Return


//----------------------------------------
// Validação do botão Próximo da página 2
//----------------------------------------
Static Function valida_pg2(cProdDe, cProdAte, cGrupo)
    If Empty(cProdAte)
        Alert("Informe um produto até!")
        Return(.F.)
    Endif	
    
    If cGrupo &lt;&gt; '0001'
        Alert("Você selecionou: " + cGrupo + " para prosseguir selecione 0001")
        Return(.F.)
    EndIf
Return(.T.)

//--------------------------
// Construção da página 3
//--------------------------
Static Function cria_pn3(oPanel)
    Local oBtnPanel := TPanel():New(0,0,"",oPanel,,,,,,40,40)
    oBtnPanel:Align := CONTROL_ALIGN_ALLCLIENT
    
    oTButton1 := TButton():New( 010, 010, "Imprimir" ,oBtnPanel,{|| Aviso("Atenção","Imprimir",{"Continuar"},1)} , 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton2 := TButton():New( 040, 010, "Consultar",oBtnPanel,{|| Aviso("Atenção","Consultar",{"Continuar"},1)}, 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )

Return