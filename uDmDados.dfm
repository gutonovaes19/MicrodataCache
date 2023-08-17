object dmdados: Tdmdados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 294
  Width = 515
  object fdConexao: TFDConnection
    Params.Strings = (
      'Database=C:\Gustavo\MicrodataCache\BD\BDTESTE.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object qryPedido: TFDQuery
    BeforePost = qryPedidoBeforePost
    OnNewRecord = qryPedidoNewRecord
    CachedUpdates = True
    OnUpdateRecord = qryPedidoUpdateRecord
    Connection = fdConexao
    SchemaAdapter = FDSchemaAdapter1
    SQL.Strings = (
      'select '
      '    ped.id,'
      '    ped.cliente,'
      '    ped.vrtotalpedido,'
      '    ped.datapedido,'
      '    ped.datadigitacao,'
      '    ped.observacao'
      'from '
      '   tbpedido ped'
      'where'
      '   ped.id = :idPedido')
    Left = 136
    Top = 24
    ParamData = <
      item
        Name = 'IDPEDIDO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryPedidoID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
    end
    object qryPedidoCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Origin = 'CLIENTE'
      Required = True
      Size = 60
    end
    object qryPedidoVRTOTALPEDIDO: TSingleField
      FieldName = 'VRTOTALPEDIDO'
      Origin = 'VRTOTALPEDIDO'
      Required = True
      currency = True
    end
    object qryPedidoDATAPEDIDO: TDateField
      FieldName = 'DATAPEDIDO'
      Origin = 'DATAPEDIDO'
      Required = True
      EditMask = '!99/99/00;1;_'
    end
    object qryPedidoDATADIGITACAO: TDateField
      FieldName = 'DATADIGITACAO'
      Origin = 'DATADIGITACAO'
      Required = True
    end
    object qryPedidoOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Origin = 'OBSERVACAO'
      Size = 200
    end
  end
  object qryItemPedido: TFDQuery
    BeforeInsert = qryItemPedidoBeforeInsert
    BeforePost = qryItemPedidoBeforePost
    OnCalcFields = qryItemPedidoCalcFields
    OnNewRecord = qryItemPedidoNewRecord
    CachedUpdates = True
    IndexFieldNames = 'PEDIDOID'
    AggregatesActive = True
    MasterSource = dspedido
    MasterFields = 'ID'
    DetailFields = 'PEDIDOID'
    Connection = fdConexao
    SchemaAdapter = FDSchemaAdapter1
    FetchOptions.AssignedValues = [evDetailCascade]
    FetchOptions.DetailCascade = True
    SQL.Strings = (
      'select'
      '   ite.id,'
      '   ite.pedidoid,'
      '   ite.produtoid,'
      '   ite.quantidade,'
      '   ite.vrunitario,'
      '   ite.descontoitem,'
      '   ite.vrtotalitem,'
      '   ite.observacao'
      'from'
      '   tbpedidoitem ite'
      'where'
      '  ite.pedidoid = :id')
    Left = 223
    Top = 16
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryItemPedidoID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      Required = True
    end
    object qryItemPedidoPEDIDOID: TIntegerField
      FieldName = 'PEDIDOID'
      Origin = 'PEDIDOID'
      Required = True
    end
    object qryItemPedidoPRODUTOID: TIntegerField
      FieldName = 'PRODUTOID'
      Origin = 'PRODUTOID'
      Required = True
      OnSetText = qryItemPedidoPRODUTOIDSetText
    end
    object qryItemPedidoCLNOMEPRODUTO: TStringField
      FieldKind = fkInternalCalc
      FieldName = 'CLNOMEPRODUTO'
      Size = 60
    end
    object qryItemPedidoQUANTIDADE: TIntegerField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Required = True
    end
    object qryItemPedidoVRUNITARIO: TSingleField
      FieldName = 'VRUNITARIO'
      Origin = 'VRUNITARIO'
      Required = True
      currency = True
    end
    object qryItemPedidoDESCONTOITEM: TSingleField
      FieldName = 'DESCONTOITEM'
      Origin = 'DESCONTOITEM'
      currency = True
    end
    object qryItemPedidoVRTOTALITEM: TSingleField
      FieldName = 'VRTOTALITEM'
      Origin = 'VRTOTALITEM'
      Required = True
      Visible = False
      currency = True
    end
    object qryItemPedidoOBSERVACAO: TStringField
      DisplayWidth = 60
      FieldName = 'OBSERVACAO'
      Origin = 'OBSERVACAO'
      Size = 200
    end
    object qryItemPedidoagTotalPedido: TAggregateField
      FieldName = 'agTotalPedido'
      Visible = True
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'SUM(VRTOTALITEM)'
    end
  end
  object dspedido: TDataSource
    DataSet = qryPedido
    Left = 136
    Top = 88
  end
  object FDSchemaAdapter1: TFDSchemaAdapter
    AfterApplyUpdate = FDSchemaAdapter1AfterApplyUpdate
    Left = 128
    Top = 152
  end
  object FDGUIxLoginDialog1: TFDGUIxLoginDialog
    Provider = 'Forms'
    Left = 424
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 432
    Top = 88
  end
  object FDGUIxErrorDialog1: TFDGUIxErrorDialog
    Provider = 'Forms'
    Left = 432
    Top = 144
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 432
    Top = 200
  end
  object MemProduto: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 112
    Top = 224
  end
end
