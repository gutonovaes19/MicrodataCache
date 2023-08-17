object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 362
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pgcontrole: TPageControl
    Left = 0
    Top = 0
    Width = 773
    Height = 362
    ActivePage = pgConsultaDados
    Align = alClient
    TabOrder = 0
    object pgConsultaDados: TTabSheet
      Caption = 'Consultar'
      object gridCsPedido: TDBGrid
        Left = 0
        Top = 84
        Width = 765
        Height = 94
        Align = alTop
        DataSource = dscsPedido
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = gridCsPedidoDblClick
        OnTitleClick = gridCsPedidoTitleClick
      end
      object gridCsItens: TDBGrid
        Left = 0
        Top = 178
        Width = 765
        Height = 156
        Align = alClient
        DataSource = dscsitem
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object pnlcsPedidos: TPanel
        Left = 0
        Top = 0
        Width = 765
        Height = 84
        Align = alTop
        TabOrder = 2
        object Label1: TLabel
          Left = 1
          Top = 70
          Width = 763
          Height = 13
          Align = alBottom
          Alignment = taCenter
          Caption = 'duplo click, seleciona para edi'#231#227'o  /exclus'#227'o'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 210
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 763
          Height = 69
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 475
            Top = 0
            Width = 288
            Height = 69
            Align = alRight
            Caption = 'Que contenham produtos'
            TabOrder = 0
            object Label7: TLabel
              Left = 2
              Top = 15
              Width = 284
              Height = 13
              Align = alTop
              Caption = 'Digite c'#243'digos de Produtos ,1 por linha,  e clique em buscar'
              WordWrap = True
              ExplicitWidth = 282
            end
            object mmProdutos: TMemo
              Left = 2
              Top = 28
              Width = 95
              Height = 39
              Align = alLeft
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object btBuscarPorProduto: TButton
              Left = 113
              Top = 41
              Width = 105
              Height = 25
              Caption = 'Buscar Pedidos '
              TabOrder = 1
              OnClick = btBuscarPorProdutoClick
            end
          end
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 166
            Height = 69
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 1
            object Button1: TButton
              Left = 16
              Top = 32
              Width = 137
              Height = 25
              Caption = 'Buscar Todos os pedidos'
              TabOrder = 0
              OnClick = Button1Click
            end
          end
          object GroupBox2: TGroupBox
            Left = 166
            Top = 0
            Width = 309
            Height = 69
            Align = alClient
            Caption = 'Por nro de Pedidos'
            TabOrder = 2
            object Label5: TLabel
              Left = 2
              Top = 15
              Width = 305
              Height = 13
              Align = alTop
              Caption = 'Digite nro de pedidos, 1 por linha e clique em buscar'
              WordWrap = True
              ExplicitWidth = 249
            end
            object mmnropedidos: TMemo
              Left = 2
              Top = 28
              Width = 95
              Height = 39
              Align = alLeft
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object btBuscarPorPedido: TButton
              Left = 112
              Top = 34
              Width = 105
              Height = 25
              Caption = 'Buscar Pedidos '
              TabOrder = 1
              OnClick = btBuscarPorPedidoClick
            end
          end
        end
      end
    end
    object pgCadastraDados: TTabSheet
      Caption = 'Cadastrar, editar, excluir'
      ImageIndex = 1
      object gridItensPedido: TDBGrid
        Left = 0
        Top = 119
        Width = 765
        Height = 215
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 765
        Height = 94
        Align = alTop
        ParentBackground = False
        TabOrder = 1
        object Pedido: TLabel
          Left = 8
          Top = 35
          Width = 32
          Height = 13
          Caption = 'Pedido'
        end
        object Label2: TLabel
          Left = 240
          Top = 35
          Width = 82
          Height = 13
          Caption = 'Data do Pedido *'
        end
        object Label3: TLabel
          Left = 254
          Top = 62
          Width = 56
          Height = 13
          Caption = 'Digitado em'
        end
        object Label4: TLabel
          Left = 421
          Top = 34
          Width = 42
          Height = 13
          Caption = 'Cliente *'
        end
        object Observações: TLabel
          Left = 6
          Top = 60
          Width = 63
          Height = 13
          Caption = 'Observa'#231#245'es'
        end
        object Label6: TLabel
          Left = 429
          Top = 61
          Width = 74
          Height = 13
          Caption = 'Total do Pedido'
        end
        object btaplicarcache: TButton
          Left = 204
          Top = 0
          Width = 99
          Height = 25
          Caption = 'Gravar Pedido'
          TabOrder = 0
          OnClick = btaplicarcacheClick
        end
        object btcancelarcache: TButton
          Left = 85
          Top = 0
          Width = 113
          Height = 25
          Caption = 'Cancelar Altera'#231#245'es'
          TabOrder = 1
          OnClick = btcancelarcacheClick
        end
        object EdtTotalPedido: TDBEdit
          Left = 508
          Top = 57
          Width = 143
          Height = 21
          TabStop = False
          DataField = 'agTotalPedido'
          ReadOnly = True
          TabOrder = 2
        end
        object btexcluirpedido: TButton
          Left = 309
          Top = 0
          Width = 100
          Height = 25
          Caption = 'Excluir Pedido '
          TabOrder = 3
          OnClick = btexcluirpedidoClick
        end
        object edtnropedido: TDBEdit
          Left = 75
          Top = 31
          Width = 95
          Height = 21
          DataField = 'ID'
          TabOrder = 4
        end
        object edtdatapedido: TDBEdit
          Left = 322
          Top = 31
          Width = 90
          Height = 21
          DataField = 'DATAPEDIDO'
          MaxLength = 8
          TabOrder = 5
        end
        object edtcliente: TDBEdit
          Left = 470
          Top = 30
          Width = 194
          Height = 21
          DataField = 'CLIENTE'
          TabOrder = 6
        end
        object edtobservacao: TDBEdit
          Left = 75
          Top = 58
          Width = 158
          Height = 21
          DataField = 'OBSERVACAO'
          TabOrder = 7
        end
        object edtdatadigiado: TDBEdit
          Left = 325
          Top = 58
          Width = 92
          Height = 21
          TabStop = False
          DataField = 'DATADIGITACAO'
          ReadOnly = True
          TabOrder = 8
        end
        object btInserir: TButton
          Left = 4
          Top = 2
          Width = 75
          Height = 25
          Caption = 'Novo Pedido'
          TabOrder = 9
          OnClick = btinserirClick
        end
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 94
        Width = 765
        Height = 25
        DataSource = dsitempedido
        Align = alTop
        TabOrder = 2
      end
    end
  end
  object dspedido: TDataSource
    DataSet = dmdados.qryPedido
    OnStateChange = dspedidoStateChange
    Left = 148
    Top = 128
  end
  object dsitempedido: TDataSource
    DataSet = dmdados.qryItemPedido
    Left = 212
    Top = 128
  end
  object dscsPedido: TDataSource
    AutoEdit = False
    DataSet = MemCsPedido
    Left = 144
    Top = 224
  end
  object dscsitem: TDataSource
    AutoEdit = False
    DataSet = MemCsItem
    Left = 220
    Top = 224
  end
  object MemCsPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 272
  end
  object MemCsItem: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 232
    Top = 280
  end
end
